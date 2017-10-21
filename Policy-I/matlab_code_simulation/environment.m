function [agent_next_location,trans_reward,next_s_type,next_state,terminal,emergency]=environment(action,current_state,type,agent_current_location,maze_coordinates,critical_distance,emergency_distance)
%outputs
%agent_next_location (4x2): new coordinates (x,y) of origin, s1,s2,s3 after
%executing the action.
%trans_reward (1x1): transition reward given a state and an action
%s_type (1x1): type of state: subhealth or health (this affect the reward
%distribution
%next_state (1x3): state vector, each component is an integers 1-3
%terminal (1 or 0): 0: state is not terminal 1: state is terminal

%inputs
%action:executed by the agent (1=forward,2=left, 3=right)
%current_state (1x3):current state vector
%type (1x1): type of current state
%agent_current_location (4x2):coordinates of agent's current position
%maze coordinates= (x,y) pairs of maze
%critical distance= boundery value between health and unhealth states
%emergency_distance= distance below this condition will force the agent to
%go backwards to avoid collision


%% estimate the new coordinates of the agent after executing the action
[agent_next_location]=agent_location(action,agent_current_location);

%% estimate new state (based on new location and sensors measurement)
[terminal,next_s_type,next_state,emergency]=state(agent_next_location,maze_coordinates,critical_distance,emergency_distance);

%% rewards
[trans_reward]=reward(action,type,current_state);

end
