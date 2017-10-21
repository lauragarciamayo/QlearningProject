% to change maze
% is_terminal for terminal state
% move_from_toward for obstacles
% last for loop in learnpolicy.m, flagging terminal states

%you can use this script for answering question 1
% report the learned policy
clc;
clear all;
close all;

%define maze
% maze = [1 1 1 1 1 1; 
%         1 0 0 1 1 1;
%         1 0 3 1 1 1;
%         1 0 0 1 1 1;
%         1 1 1 1 1 2] %1000 iterations

% maze = [1 1 1 1;
%         1 0 0 1;
%         1 0 3 1;
%         1 0 0 2] %1000 iterations
% 
maze = [2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
        1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
        1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
        1 0 1 0 0 0 0 1 0 1 0 0 0 0 1 1;
        1 0 1 0 0 0 0 1 0 1 0 0 0 0 0 1;
        1 1 1 0 0 0 0 1 0 1 0 1 1 0 0 1;
        1 0 1 1 1 1 1 1 0 1 0 1 1 0 0 1;
        1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1;
        1 1 1 1 1 1 1 1 0 1 1 1 1 0 0 3;
        1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0]
    
[nr nc] = size(maze)
% maze --> 0=obstacle, 1=okay state, 2=start state, 3=goal state 

%Important note: Your code should return a policy in less than 7 minutes
tic;
policy = learnpolicy( @next_state, maze )
toc;


%to show policy as a grid
for i=1:(nr*nc)
    r=ceil(i/nc);
    c=mod(i,nc);
    if c==0
    c=nc;
    end
    map(r,c)=policy(i);
end

map

%get the path from start state to goal
start_state = find(maze(:,:)'==2); %always starting from same state, not exploring start
end_state = find(maze(:,:)'==3); %always starting from same state, not exploring start

[ start_i start_j ] = pos_in_maze(start_state,nr,nc);
pos = [start_i start_j]

state = start_state;
terminal=0;
reward=0;
while(terminal==0)
    [ pos_i pos_j ] = pos_in_maze(state,nr,nc);
    
    action = policy(state)
    
    if (action==1)%move to right
        next_pos_i=pos_i ;
        next_pos_j=pos_j+1;
    elseif (action==2)%move to north
        next_pos_i=pos_i-1 ;
        next_pos_j=pos_j;
        
    elseif (action==3)%move to left
        next_pos_i=pos_i ;
        next_pos_j=pos_j-1;
        
    else
        %move to south
        next_pos_i=pos_i+1 ;
        next_pos_j=pos_j;
        
    end
    
    next_state_1 = (next_pos_i-1)*nc+next_pos_j;
    state = next_state_1;
    
    pos = [pos;next_pos_i next_pos_j];
    [ terminal,reward ] = is_terminal( next_pos_i,next_pos_j,maze );
end

pos

maze = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
        1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
        1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
        1 0 1 0 0 0 0 1 0 1 0 0 0 0 1 1;
        1 0 1 0 0 0 0 1 0 1 0 0 0 0 0 1;
        1 1 1 0 0 0 0 1 0 1 0 1 1 0 0 1;
        1 0 1 1 1 1 1 1 0 1 0 1 1 0 0 1;
        1 0 0 0 0 0 0 1 0 1 0 0 1 0 0 1;
        1 1 1 1 1 1 1 1 0 1 1 1 1 0 0 1;
        1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0]
    
    comet_mod(pos(:,2),pos(:,1),maze)