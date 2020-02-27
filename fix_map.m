% clear all; clc; close all
load('map.mat');
hold on;
for i=1:length(map_x)
    i
    for j=1:length(map_y)
        for k=length(map_z):-1:1
            
            
            if map(i,j,k)==1 && map_z(k)<40
                for k=k:-1:1
                    map(i,j,k)=1;
                end
                
                break
            end
            
            
        end
    end
end

xlabel('x');ylabel('y');zlabel('z')
view([0 0]);
