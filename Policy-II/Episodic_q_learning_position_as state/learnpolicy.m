function [ policy ] = learnpolicy( environment, maze )
%LEARNPOLICY Summary of this function goes here
%   environment is just a function handle to next_state
%   start_state is the index of the starting state
%   policy will be a row vector of size 1*16 
%   each element of this vector will be a positive integer from 1 to 4
%   This vector should contain the learned policy
%   For example, policy(1) should be the best action for state=1
%                policy(2) should be the best action for state=2                  
%                                       .
%                                       .
%                                       .
%                policy(16) should be the best action for state=16                  
%   Implement an RL method here

%Qlearning, sutton figure 6.12

[nr nc] = size(maze);

nStates = nr*nc;

episodes=10000 %number of episodes, can increase the value as much depending on if policy converges or not

Q=zeros(nStates,4); % policy-action pair (16 states/4 actions)
a=[1 2 3 4]; % set of actions
n_actions = 4;
policy=zeros(1,nStates); %policy
qval=zeros(1,nStates); %max Q value
epsilon=0.1; % epsilon greedy, prob of choosing action randomly
gamma=0.9; %discount factor
alpha=0.1; %step size constant

%%takes more time if epsilon=0.5 and gamma = 0.5

for i=1:episodes
    
    %initialize first state
    terminal=0;
        
    %selecting the start state randomly
    valid_states = [find(maze(:,:)'==1); find(maze(:,:)'==2)];
    %valid_states = [find(maze(:,:)'==1)];
    nV = size(valid_states);
    val = randi(nV(1));
    start_state = valid_states(val);
    
    %start_state = find(maze(:,:)'==2); %always starting from same state, not exploring start
    
    s = start_state;
   
    %episode run until we find a terminal state
    while (terminal==0)
         
        %choose first action, epsilon greedy
        [value index] = max(Q(s,:));
        if rand<(1-epsilon) %uniformly distributed random number
            a=index;
        else
        a=randi(n_actions);
        end
         
        [terminal, snext, reward]=environment(s,a,maze);
        
        %choose action of snext, epsilon greedy
        [value index] = max(Q(snext,:));
        
        a_next=index; %choosing action with max Q value
        
        Q(s,a)=Q(s,a)+alpha*(reward+gamma*Q(snext,a_next)-Q(s,a));
        s=snext;
        a=a_next;
    end
end

obstacles = find(maze(:,:)'==0);
terminal_state = find(maze(:,:)'==3);
nO = size(obstacles);

for i=1:nStates
    [qval(i) policy(i)]=max(Q(i,:));
    for j=1:nO(1)
        if (i==obstacles(j))
            policy(i) = 0;%flag, terminal states/obstacles or untraversed states         
        end 
    end
    if (i==terminal_state)
            policy(i) = 0;%flag, terminal states/obstacles or untraversed states         
    end
end
end



