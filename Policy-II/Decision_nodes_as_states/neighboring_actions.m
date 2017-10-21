function [ neighbors ] = neighboring_actions( a )
%NEIGHBORING_ACTIONS This function returns the neighboring actions

    if ((a==1) || (a==3))
        neighbors=[2 4];
    else
        neighbors=[1 3];
    end


end

