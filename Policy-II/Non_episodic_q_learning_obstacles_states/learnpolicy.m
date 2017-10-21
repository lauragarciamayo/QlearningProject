function [ policy ] = learnpolicy( maze )
%LEARNPOLICY Summary of this function goes here
%   environment is just a function handle to next_state
%   start_state is the index of the starting state
%   
% Qlearning, sutton figure 6.12
% There are four actions - ENWS, or 1234
% There are sixteen states- position of obstacles in a state
% [0 0 0 0] - no obstacle
% [1 0 0 0] - obstacle on east
% [0 1 0 0] - obstacle on North
% [0 0 1 0] - obstacle on west
% [0 0 0 1] - obstacle on south
%[1 1 0 0] - 6 states with two walls
%[1 0 1 0]
%[1 0 0 1]
%[0 1 1 0]
%[0 1 0 1]
%[0 0 1 1]
%[1 1 1 0] - 4 states with three walls
%[1 0 1 1]
%[1 1 0 1]
%[0 1 1 1]
%[1 1 1 1] - state with four walls- should not be there ever

nStates = 16;
Q=zeros(nStates,4); % policy-action pair (16 states/4 actions)
% Q = [0         0         0         0;
%   -68.6852   35.9473   35.6196   35.7343;
%    35.8505  -68.6775   35.7369   35.6510;
%     0.4000         0         0         0;
%          0         0         0         0;
%   -69.2425  -69.1808   35.1807   35.3639;
%   -68.2790   36.4901  -68.2721   33.5999;
%   -59.1281    1.5983   10.6274  -31.9652;
%          0         0         0         0;
%    36.4904  -68.2243   35.7168  -68.2236;
%    36.2969   36.3377  -68.3783  -68.3810;
%          0         0         0         0;
%   -10.1000    0.4000  -19.1900         0;
%          0         0         0         0;
%          0         0         0         0;
%          0         0         0         0];
     
a=[1 2 3 4]; % set of actions, ENWS
n_actions = 4;

qval=zeros(1,nStates); %max Q value
epsilon=0.5; % epsilon greedy, prob of choosing action randomly
gamma=0.9; %discount factor
alpha=0.2; %step size constant

terminal=0;
[nr nc] = size(maze);
start_pos = find(maze(:,:)'==2);

[i_sp j_sp] = pos_in_maze(start_pos,nr,nc);
policy= [i_sp j_sp]; % policy is the trajectory of the robot
pos = [i_sp j_sp];         
[s reward_vector]= find_state(i_sp,j_sp,maze); %finding the state
   
%run until we find a terminal state
ind_s = 0;
while (terminal==0)
         
        %choose first action, epsilon greedy
        [value index] = max(Q(s,:));
        if rand<(1-epsilon) %uniformly distributed random number
            a=index;
        else
        a=randi(n_actions);
        end
         
        reward_a = reward_vector(a); %somehow not choose the acton that budge in wall
        
        %move the robot to next grid cell, according to current position
        %and action from above and find next state vector
        
        [terminal, posnext_i,posnext_j, reward]=next_state(pos,s,a,maze);% dont use this reward, it corresponds to ifterminal=10 ifnotterminal=-1
        
        %change pos to states
        [snext reward_vector_next]= find_state(posnext_i,posnext_j,maze); %finding the state
        
        %choose action of snext, epsilon greedy
        [value index] = max(Q(snext,:));
        
        a_next=index; %choosing action with max Q value
        
        Q(s,a)=Q(s,a)+alpha*(reward+gamma*Q(snext,a_next)-Q(s,a));
        
        %Q(s,a)=Q(s,a)+alpha*(reward+reward_a+gamma*Q(snext,a_next)-Q(s,a)); %conceptually this is better, over the time telling robot to not go in obstacle direction.
        
        s=snext;
        a=a_next;
        pos = [posnext_i posnext_j]
        policy= [policy; pos]; % policy is the trajectory of the robot
        ind_s = ind_s+1;
        reward_vector = reward_vector_next;
        Q
end
ind_s
Q
end



