function [ neighbor ] = move_from_toward( i, j, a,maze )
%MOVE_FROM_TOWARD This function move the agent from position (i,j) toward a
%   i is the row of the grid
%   j is the column of the grid
%   a is an action
%   0 value in the maze is obstacle 
%   Move the agent toward a if the action a does not lead you toward an
%   obstacle or the wall
%   otherwise, stay at the same place
%   
    neighbor=[i j];% I assume that I cannot move because of an obstacle or wall
    temp_neighbor= move_toward(i,j,a);
    r=temp_neighbor(1);%the row of the resulting action
    c=temp_neighbor(2);%the column of the resulting action
    
    %now, I check if [r c] is an obstacle 
    [nr nc] = size(maze);
    obstacles = find(maze(:,:)'==0);
    nO = size(obstacles);
    flag = 0;
    
    if ( (r>=1) && (r<=nr) && (c>=1) && (c<=nc) )
        for ind= 1:nO
            or = ceil(obstacles(ind)/nc);
            oc = mod(obstacles(ind),nc);
            if oc==0
                oc = nc;
            end
            if((r == or)&&(c == oc))
                flag=1;
                break
            end 
        end
        if flag==0
            neighbor=[r c];
        end
    end
end

