function [next_state]=next_state(agent_next_location,maze)

%measurement from sensors
s=zeros(1,3);
for i=1:3
    s(1,i)=sonar(agent_next_location,maze,i);
end

[Max,index_max]=max(s);
[Min,index_min]=min(s);

%state vector (each component is an integer from 1-3)
next_state=zeros(1,3);
next_state(index_max)=3;
next_state(index_min)=1;
for i=1:3
    if next_state(i)==0
        next_state(i)=2;
    end
end