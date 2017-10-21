function state_integers=euclideanDistance2integers(start_state)

%State vector, each component expresed with an integer from 1-3
%[left front right]
[Max,index_max]=max(start_state);
[Min,index_min]=min(start_state);

state_integers=zeros(1,3);
state_integers(index_max)=3;
state_integers(index_min)=1;

for i=1:3
    if state_integers(i)==0
       state_integers(i)=2;
    end
end