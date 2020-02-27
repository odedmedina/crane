% clear all; clc; close all
load('map.mat');
hold on;
for i=1:length(map_x)
    i
    for j=61:61
        for k=1:length(map_z)
            
            
            if map(i,j,k)==1
                plot3(map_x(i),map_y(j),map_z(k),'xk');
            else
                plot3(map_x(i),map_y(j),map_z(k),'og');
            end
            
            
        end
    end
end

xlabel('x');ylabel('y');zlabel('z')
view([0 0]);
