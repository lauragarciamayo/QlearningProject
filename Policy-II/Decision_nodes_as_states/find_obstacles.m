%This function simulates the environment, assuming robot is somewhere and
%it uses input from four sensors to check if there is an obstacle in nsew
%direction

function [obstacles] = find_obstacles(i,j, maze)

obs = [0 0 0 0];
obstacles = find(maze(:,:)'==0);
nO = size(obstacles);

[nr nc] = size(maze);
%check east
r = i;
c = j+1;
if ( (r>=1) && (r<=nr) && (c>=1) && (c<=nc) )
    for ind= 1:nO
            or = ceil(obstacles(ind)/nc);
            oc = mod(obstacles(ind),nc);
            if oc==0
                oc = nc;
            end
            if((r == or)&&(c == oc))
                obs(1) = 1;
                break
            end 
    end
else
    obs(1) = 1;
end

%check north
r = i-1;
c = j;
if ( (r>=1) && (r<=nr) && (c>=1) && (c<=nc) )
    for ind= 1:nO
            or = ceil(obstacles(ind)/nc);
            oc = mod(obstacles(ind),nc);
            if oc==0
                oc = nc;
            end
            if((r == or)&&(c == oc))
                obs(2) = 1;
                break
            end 
    end
else
    obs(2) = 1;
end

%check west
r = i;
c = j-1;
if ( (r>=1) && (r<=nr) && (c>=1) && (c<=nc) )
    for ind= 1:nO
            or = ceil(obstacles(ind)/nc);
            oc = mod(obstacles(ind),nc);
            if oc==0
                oc = nc;
            end
            if((r == or)&&(c == oc))
                obs(3) = 1;
                break
            end 
    end
else
    obs(3) = 1;
end

%check south
r = i+1;
c = j;
if ( (r>=1) && (r<=nr) && (c>=1) && (c<=nc) )
    for ind= 1:nO
            or = ceil(obstacles(ind)/nc);
            oc = mod(obstacles(ind),nc);
            if oc==0
                oc = nc;
            end
            if((r == or)&&(c == oc))
                obs(4) = 1;
                break
            end 
    end
else
    obs(4) = 1;
end

obstacles = obs;
end

