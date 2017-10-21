function [ neighbor ] = move_toward( i, j, a )
%MOVE_TOWARD This function move the agent from position (i,j) toward a
%regardless of whether the destination is an obstacle or inside the grid
%   i is the row of the grid
%   j is the column of the grid
%   a is an action
    if (a==1)%move to right
        neighbor=[i j+1];
    elseif (a==2)%move to north
        neighbor=[i-1 j];
    elseif (a==3)%move to left
        neighbor=[i j-1];
    else
        %move to south
        neighbor=[i+1 j];
    end
end

