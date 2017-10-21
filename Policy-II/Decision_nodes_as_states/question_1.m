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
policy = learnpolicy( @next_state, maze );
toc;

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

comet_mod(policy(:,2),policy(:,1),maze);

