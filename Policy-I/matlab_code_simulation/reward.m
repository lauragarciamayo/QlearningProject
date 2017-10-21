function [reward]=reward(action,s_type,current_state)


%% assign rewards to state vector
[Max,index_max]=max(current_state);
[Min,index_min]=min(current_state);

if action==4 %special action, emergency
    reward=0;
else
    %action= 1:forward,2=left,3=right
    if index_max==action %best reward
        switch s_type
            case 1
                reward=0;
            case 2
                reward=5;
        end
    elseif index_min==action %worst reward
        switch s_type
            case 1
                reward=-3;
            case 2
                reward=0;
        end
    else
        switch s_type
            case 1
                reward=-1;
            case 2
                reward=1;
        end

    end
end
