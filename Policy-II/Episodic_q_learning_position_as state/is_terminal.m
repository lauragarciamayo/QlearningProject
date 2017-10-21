function [ terminal,reward ] = is_terminal( i,j,maze )
%IS_NON_TERMINAL This function checks whether [i, j] is a terminal state or not
%   
%   
    %r=[10 0 0 0];
    %r=[10 5 -5 -10];
    %All the cells in the last column are terminal states

%%%here we define the terminal state

    term_state = find(maze(:,:)'==3);
    [nr nc] = size(maze);
    
    tr = ceil(term_state/nc);
    tc = mod(term_state,nc);
    if tc==0
       tc = nc;
    end
    
    if(i==tr && j==tc)
        terminal = 1;
        reward = 10;
    else
        terminal = 0;
        reward = -1;
    end
        
end

