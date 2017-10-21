function [next_location]=left_right_action(angle_new, origin,r)

    %this function returns the coordinates of the agent after rotating
    %either to the right or to the left
    
    %fixed separation between point
    sep=90; %[deg]
    
    %accumulated angle wrt reference x-axis
    persistent angle_prev
    
    if isempty(angle_prev) 
        angle_prev=0;
    end

    angle=angle_new+angle_prev;
    %initial coordinates
    s1=[origin(1)+r*cosd(angle),origin(2)+r*sind(angle)]; %reference point
    s2=[origin(1)+r*cosd(angle+sep),origin(2)+r*sind(angle+sep)];
    s3=[origin(1)+r*cosd(angle+(2*sep)),origin(2)+r*sind(angle+(2*sep))];
    next_location=cat(1,origin,s1,s2,s3);
    angle_prev=angle;
   
end
    