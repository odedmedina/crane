function [inobs] = map_check(xx,yy,zz)
global map_x map_y map_z map max_ptp crane_h l2
% max_ptp=max_ptp*0.5;

if zz<1
    zz=1;
end
if zz>crane_h-l2
    zz=crane_h-l2;
end


inobs=1;
% [find(map_x==round(x)),find(map_y==round(y))+1,find(map_z==round(z))]

x=find(map_x==round(xx));
y=find(map_y==round(yy));
z=find(map_z==round(zz));

try

  
    if map(x,y+max_ptp)<z-2 && map(x,y)<z-2 && map(x,y-max_ptp)<z-1
        if  map(x-max_ptp,y+max_ptp)<z-2 && map(x-max_ptp,y)<z-2 && map(x-max_ptp,y-max_ptp)<z-1 %%%%%%% z -1
            if  map(x+max_ptp,y+max_ptp)<z-2 && ~map(x+max_ptp,y)<z-2 && map(x+max_ptp,y-max_ptp)<z-1
                
                inobs=0;
              
            end
            
        end
    end
    
%     
catch
end

end