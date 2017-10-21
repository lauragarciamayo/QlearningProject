function [type]=state_type(state,critical_distance)

%% Find out the type of state: health or subhealth
for i=1:3
    if state(i)<critical_distance %subhealth state
        type=1; 
        break
    else
        type=2; %health state
    end
end
end