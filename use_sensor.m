clc; close all; clear all
x_offset=-34; y_offset=27;
%
try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end
flushinput(u);


map_x=-60:1:60;
map_y=-60:1:60;
map_z=-5:1:50;

% map=zeros(length(map_x),length(map_y));

for i=1:length(map_x)
    toc
    tic
    i
    for j=1:length(map_y)
        for k=length(map_z):-1:1
            
            flushinput(u);
            fwrite(u,[map_x(i)+x_offset,map_y(j)+y_offset,map_z(k),0],'double');
            
            temp1=fread(u,7,'double');
            map(i,j,k)=temp1(7);
            if map(i,j,k)==1 && map_z(k)<40
                for k=k:-1:1
                    map(i,j,k)=1;
                end
                
                break
            end
            if map_z(k)<1
                  map(i,j,k)=1;
            end
            
        end
    end
end
save('map.mat','map','map_x','map_y','map_z');
% plot_map

