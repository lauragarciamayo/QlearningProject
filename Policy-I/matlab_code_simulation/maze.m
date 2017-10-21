function [maze_coordinates]=maze()

t = linspace(0,4*pi,1000);
x = t.*cos(t);
y = t.*sin(t);
maze_coordinates=[x;y];
%plotting
plot(x,y,'b');
xlim([min(x)-3 max(x)+3]);
ylim([min(y)-3 max(y)+3]);
hold on
end