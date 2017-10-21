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

[nr nc] = size(maze);

%max_nStates = nr*nc;
max_nStates = 150;
nStates = 0; %initialise the number of state, they will grow as we traverse in the maze

a=[1 2 3 4]; % set of actions
n_actions = 4;

state_pos_vector = zeros(max_nStates,4);%2-pos(i,j),1-number of visits,last_action 
state_info_vector= zeros(4,4,max_nStates);%|4-surrounding obstacles (ENWS)| 4-actions| 4-rewards| 4-corresponding next states

start_pos_cell = find(maze(:,:)'==2);
[start_pos(1) start_pos(2)] = pos_in_maze(start_pos_cell,nr,nc);

policy=start_pos; %the trajectory traversed

terminal=0;
ind_p=1;        
last_action = 4;
last_visited_state = 1; %index in the state vector
state_pos_vector(last_visited_state,4)= 4;
%run until we find a terminal position
while (terminal==0)
        
   pos = policy(ind_p,:);
        
   obstacles = find_obstacles(pos(1),pos(2),maze);
           
   back_direction = mod((last_action+2),4);
   if back_direction ==0
       back_direction = 4;
   end
        
   neighbors  = neighboring_actions( last_action );
   sum_obs = obstacles(last_action)+obstacles(neighbors(1))+obstacles(neighbors(2));
   
   ind_p
   if(ind_p == 116)
       pos
       obstacles
       back_direction
       back_direction
       sum_obs
       
   end
   
   if(sum_obs == 0 || sum_obs == 1 )
       %state_pos_vector = zeros(max_nStates,4);%2-pos(i,j),1-number of visits,last_action 
       %state_info_vector= zeros(4,4,max_nStates);%|4-surrounding obstacles (ENWS)| 4-actions| 4-rewards| 4-corresponding next states
       
       %check if state is new or has been previously visited
       current_state_pos_vector = state_pos_vector(:,1:2);
       if(ismember(pos,current_state_pos_vector,'rows'))
           %if previously visited, the give -ve reward to last states
           match_array = ismember(current_state_pos_vector,pos,'rows');
           match_row = find(match_array==1);
           state_pos_vector(match_row,3) = state_pos_vector(match_row,3)+1 ; 
           state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = -100;
           %state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state)-100;
           state_info_vector(4,(state_pos_vector(last_visited_state,4)),last_visited_state) = match_row;
           state_index = match_row;
           if(ind_p==116)
               match_row
               'ismember'
           end
       else
           %if new add to state vector, also update reward for last state
           nStates = nStates+1;
           state_pos_vector(nStates,1:2) = pos;
           state_pos_vector(nStates,3) = 1;
           
           state_info_vector(1,:,nStates) = obstacles; %position of obstacles
           state_info_vector(2,:,nStates) = 1-obstacles;  %available actions
           
           state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = 10;
           %state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state)+10;
           state_info_vector(4,(state_pos_vector(last_visited_state,4)),last_visited_state) = nStates;
           
           state_index = nStates;
           if(ind_p == 116)
               'hey'
               state_index
               state_info_vector(1,:,state_index)
               state_info_vector(2,:,state_index)
               
           end
       end
             
       max_reward_action = back_direction;
       if (ind_p == 116)
           max_reward_action
           back_direction
           state_info_vector(2,:,state_index)
           state_info_vector(3,:,state_index)
           state_info_vector(:,:,state_index)
       end
           
       for i =1:4
           if(state_info_vector(2,i,state_index)==1 && i ~= back_direction && state_info_vector(3,i,state_index)>= state_info_vector(3,max_reward_action,state_index))
               max_reward_action = i;
               if (ind_p == 116)
               max_reward_action 
               end
           end
       end
       
       %action
       action = max_reward_action;
       
       %take action with maximum reward
       state_pos_vector(state_index,4) = action;
       
       %update last_visited_state
       last_visited_state = state_index;
   elseif (sum_obs ==2)
       %action = last_action; %keep moving straight
       %choose the only available action in which direction there is no
       %obstacle
       
       if(obstacles(last_action) ~= 1)
           action = last_action;
       end
       if(obstacles(neighbors(1)) ~= 1)
           action = neighbors(1);
       end
       if(obstacles(neighbors(2)) ~= 1)
           action = neighbors(2);
       end
       
   elseif (sum_obs == 3)
       action = back_direction;
       %update reward to -100
       %last_visited_state ->last_action->reward
       state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = -100;
       %state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) = state_info_vector(3,(state_pos_vector(last_visited_state,4)),last_visited_state) -100;
   else
       'some logical problem'
       break;
   end

   %take action, update position
   last_action = action;
   
   if (action==1)%move to right
        next_pos=[pos(1) pos(2)+1];
   elseif (action==2)%move to north
        next_pos=[pos(1)-1 pos(2)];
   elseif (action==3)%move to left
        next_pos=[pos(1) pos(2)-1];
   else
        %move to south
        next_pos=[pos(1)+1 pos(2)];
   end
   
   policy=[policy ; next_pos(1) next_pos(2)];
      
   terminal = is_terminal( next_pos(1), next_pos(2),maze )
   %if(ind_p == 116)
        %terminal=1;
   %end
   ind_p = ind_p+1;
end
state_pos_vector;
state_info_vector;
end



