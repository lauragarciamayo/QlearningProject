%TEST
clear all
close all
clc

%% the maze
[maze_coordinates]=maze(); %spiral

%% agent and its initial condition

%The agent is modeled as a circle of radius r and 4 reference
%points (origin and 3 sensors). Sensors are spaced 90degrees to each other
%(front and two lateral).
       
% initial location of the agent
origin=[-1.5,-0.1]; %origin coordinate (x,y)
angle=60; %offset angle (of the x-axis of the cartesian coordinates in agent's reference frame)
r=0.4; %radius of circle r

%Location arrays as 'next_location' and 'current_location' are 4x2 arrays that 
%contain the coordinates (x,y) of the origin,sensor1,sensor2,sensor3 
%initial locationc coordinates
initial_location=left_right_action(angle, origin,r);

%trajectory array store the coordinates (x,y) of the origin of the agent
%while he finds its way out the maze
j=1;
trajectory(j,:)=initial_location(1,:); %initial coordinates of origin

% plot initial position
circle(initial_location(1,1),initial_location(1,2),r);
hold on
    for i=1:4
        plot(initial_location(i,1),initial_location(i,2),'o','MarkerSize',4)
    end

%% initial state 

%subhealth condition
critical_distance=1; %when any of the euclidian distances (sensor-maze) goes 
%below the critical distance the agent falls in subhealth state
emergency_distance=0.2; %if distance is below this condition, the next action is to go backwards to avoid collision

[terminal,type,start_state,emergency]=state(initial_location,maze,critical_distance,emergency_distance);

%state index (to address state in the Q matrix, there are 12 states:6 health and 6 subhealth)
s_index=state_index(start_state,type);


%% Exploration

Nepisodes=4; %number of episodes

a=[1 2 3];    %set of actions
Nactions = length(a);

Q=zeros(12,3);  % action-value function (12 states: 6 subhealth and 6 health/3 actions)

gamma=0.9; %discount factor, the closer to 1 the faster the convergence
alpha=0.1; %step size constant
epsilon=0.1; % epislon for e-greedy policy, probability of choosing a random action 

for i=1:Nepisodes
    
    terminal=0;
    
    %initialize state
    s=start_state; 
    location=initial_location;

    %episode run until we find a terminal state
    while (terminal==0)

        %choose action of next_state (e-greedy)
        if emergency==1
            a=4; %go backwards to avoid collision
        else
            if rand<(1-epsilon)
                [q a] = max(Q(s_index,:)); 
            else
                a=randi(Nactions);
            end
        end

        %execute action and reach next state
        [agent_next_location,reward,next_s_type,next_state,terminal,emergency]=environment(a,s,type,location,maze_coordinates,critical_distance,emergency_distance);
        
        %update trajectory of origin of agent to be plotted
        j=j+1;
        trajectory(j,:)=agent_next_location(1,:);
        
        %index of next state
        s_index_next=state_index(next_state,next_s_type);
        
        if a~=4 %emergency
            %update Q
            Q(s_index,a)=Q(s_index,a)+alpha*(reward+gamma*max(Q(s_index_next,:))-Q(s_index,a));
        end
        
        %update state, location and type of state
        s=next_state;
        location=agent_next_location;
        type=next_s_type; %update type of state
        s_index=s_index_next;
        
        %% plot last episode
%         if i==Nepisodes
%             figure(2)
%             [maze_coordinates]=maze();
%             plot(location(1,1),location(1,2),'o','MarkerSize',5); %only the origin
%             hold on
%         end
    end
    
end

