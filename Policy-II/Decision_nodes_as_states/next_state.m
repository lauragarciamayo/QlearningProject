function [ terminal, snext, reward ] = next_state( s,a,maze )
%NEXT_STATE is your interface to the dynamic of the environment which you
%want to experience and extract a ploicy

%   s denotes the current state
%   a denotes the action; a belongs to {1, 2, 3, 4}
%   snext is the next state
%   reward is the immediate transition reward
%   terminal is a boolean
%   if terminal==0, snext is non_terminal otherwise it is a terminal state
%   indicating the end of an episode

    [nr nc] = size(maze);

    noise_prob=0.2;

    r=ceil(s/nc);
    c=mod(s,nc);
    if c==0
        c=nc;
    end
    
    neighbors=extract_neighbor(r,c,a,noise_prob,maze);
    
    trans_prob=cumsum(neighbors(:,3));
    rand_num=rand;
    next_index=0;
    for i=1:3
        if rand_num <= trans_prob(i)
            next_index=i;
            break;
        end
    end
    
    r=neighbors(next_index,1);
    c=neighbors(next_index,2);
    
    snext=((r-1)*nc)+c;
        
    [terminal, reward]=is_terminal(r,c,maze);   
        
end

