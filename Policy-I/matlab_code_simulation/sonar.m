function [distance_from_maze]=sonar(next_location,maze,sensor_number)

switch sensor_number
   case 1 %lateral right
      p2=next_location(2,:);
   case 2 %front
      p2=next_location(3,:);
   case 3 %lateral left
      p2=next_location(4,:);
   otherwise
end

%% Find the line connecting the origin (p1) and sensor (p2)

p1=next_location(1,:); %origin
if p2(1)==p1(1) %singularity, dividing by zero
    x2=p2(1)*ones(1,length(linspace(min(maze(2,:)),max(maze(2,:)))));
    y2 = linspace(min(maze(2,:)),max(maze(2,:)));
else %line connecting origin and sensor point
    slope=(p2(2)-p1(2))/(p2(1)-p1(1));
    b=p1(2)-slope*p1(1);
    x2 = linspace(min(maze(1,:)),max(maze(1,:)));
    y2= slope.*x2+b;
end

%% Find the intersection of the maze and line

%all the intersections of line and spiral
P_array = InterX([maze(1,:);maze(2,:)],[x2;y2]);

% plot(maze(1,:),maze(2,:),x2,y2);

if ~isempty(P_array) %only if there are intersections
    Npairs=size(P_array);
    for i=1:Npairs(2)  %euclidean distance between intersection point and sensor (calculated for each intersection point of the P_array)
        %euclidean distance 
        euclidean_distance(i)=sqrt((P_array(1,i)-p2(1))^2+(P_array(2,i)-p2(2))^2);
    end
    %find the desired intersection point (select point with shortest euclidean
    %distance and making a 0-deg angle between vectors origin-intersection and
    %origin-sensor. This is to avoid selecting the opposite intersection (e.g
    %the interception on the right side for the sensor on the left side, givin
    %an angle of 180deg)
    [distance_from_maze,index]=min(euclidean_distance); %intersection point closest to p2
    
    for i=1:Npairs(2)
        %change of 180deg
        vectorA=[(next_location(1,1)-P_array(1,index)) (next_location(1,2)-P_array(2,index))]; %origin- intersection
        vectorB=[(next_location(1,1)-next_location(sensor_number+1,1)) (next_location(1,2)-next_location(sensor_number+1,2))];%origin-sensor
        angle=acos(dot(vectorA,vectorB)/(norm(vectorA)*norm(vectorB)))*180/pi;
        
        if round(real(angle))==180 && Npairs(2)>1
            euclidean_distance(index) = [];  
            P_array(:,index)=[];
            [distance_from_maze,index]=min(euclidean_distance);
            Npairs=size(P_array);
        elseif round(real(angle))==180 && Npairs(2)==1
            distance_from_maze=100; %far from maze
        end
    end

else
    distance_from_maze=100;
end
if distance_from_maze~=100
%     plot(P_array(1,index),P_array(2,index),'ro');
end
end