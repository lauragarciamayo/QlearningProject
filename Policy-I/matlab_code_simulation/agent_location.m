function [next_location]=agent_location(action,current_location)
    
%constants
   forward_distance=0.5; %distance to travel when  forward action is chosen
   %radius of agent (distance between origin and any sensor)
   r=sqrt((current_location(1,1)-current_location(2,1))^2+(current_location(1,2)-current_location(2,2))^2);

%% Estimate new location for a given action

if action==4 %emergency
    %same as forward but add an angle phase of -180 to s2 (oposite point in
    %the circle)
    %change of origin
    %calculate coordinates of s2 (front of agent) for a circle centered in 
    %old origin, with radius of forward_distance, with angle offset    
    [next_location]=left_right_action(-180, current_location(1,:), 0.8*forward_distance);
    %thw new origin is the point s2
    origin=next_location(3,:);
    [next_location]=left_right_action(0,origin, r);
    
elseif  action==1 %forward
    %change of origin
    %calculate coordinates of s2 (front of agent) for a circle centered in 
    %old origin, with radius of forward_distance, with angle offset    
    [next_location]=left_right_action(0, current_location(1,:), forward_distance);
    %thw new origin is the point s2
    origin=next_location(3,:);
    [next_location]=left_right_action(0,origin, r);
    
elseif action==2 %left
    angle=15; %[deg]
    %origin remains the same and robot rotates to left or right
    [next_location]=left_right_action(angle, current_location(1,:),r);
    
else %action==3 %right
    angle=-15; %[deg]
    [next_location]=left_right_action(angle, current_location(1,:),r);
end

%% plot next position
% circle(next_location(1,1),next_location(1,2),r);
% hold on
%     for i=1:4
%         plot(next_location(i,1),next_location(i,2),'o','MarkerSize',4)
%     end
plot(next_location(1,1),next_location(1,2),'o','MarkerSize',5); %only the origin
end
