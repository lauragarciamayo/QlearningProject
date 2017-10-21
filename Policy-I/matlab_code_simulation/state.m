function [terminal,next_s_type,next_state,emergency]=state(agent_next_location,maze,critical_distance,emergency_distance) %next state is array of euclidean distances

%% measurement from sensors
s=zeros(1,3);
for i=1:3
    [s(1,i)]=sonar(agent_next_location,maze,i);
end
%check emergency case
for i=1:3
    if s(1,i)<=emergency_distance
        emergency=1;
        break
    else
        emergency=0;
    end
end
% [front left right]
next_state_distance=[s(2) s(3) s(1)];  %euclidian distances
next_state=euclideanDistance2integers(next_state_distance); %state vector (1-3)

%% find out the type of state (health or subhealth)
[next_s_type]=state_type(next_state_distance,critical_distance);

%% detect termination state

% THIS SHOULD BE THE LOGIC FOR REAL SENSORS
termination_distance=100;

cont=0;
% if next_state(1)>termination_distance && next_state(2)>termination_distance && next_state(3)>termination_distance
for i=1:3
    if next_state_distance(i)==100;
        cont=cont+1;
    end
end
if cont>=2
    terminal=1;
else 
    terminal=0;
end

end