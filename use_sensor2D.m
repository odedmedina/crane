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

% map_z=0:1:20;
map_z=0:1:40;

map=zeros(length(map_x),length(map_y));
tic
for i=1:length(map_x)
    toc
    tic
    i
    for j=1:length(map_y)
        for k=length(map_z):-1:1
            
          
            fwrite(u,[map_x(i)+x_offset,map_y(j)+y_offset,map_z(k),0],'double');
              fclose(u);
            flushinput(u);
            fopen(u);
            temp1=fread(u,7,'double');
            
            if temp1(7) 
                    map(i,j)=map_z(k);
%                     disp(map_z(k));
                break
            end
            
            if map_z(k)<1
                  map(i,j)=1;
            end
            
        end
                   
    end
end
save('map2.mat','map','map_x','map_y','map_z');
% plot_map
surf(map_x,map_y,map')

% map(59:63,59:63)=48; 

% map(39,47:116)=14;
% map(29,47:116)=14;
% 
% map(38,47:116)=15;
% map(30,47:116)=15;
% 
% map(37,47:116)=16;
% map(31,47:116)=16;
% 
% map(36,47:116)=17;
% map(32,47:116)=17;
% 
% map(35,47:116)=18;
% map(33,47:116)=18;
% 
% 
% map(34,47:116)=19;
% 






