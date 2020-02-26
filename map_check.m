function [inobs] = map_check(xx,yy,zz)
global map_x map_y map_z map max_ptp
% max_ptp=max_ptp*0.5;
if zz<1
    zz=1;
end



inobs=1;
% [find(map_x==round(x)),find(map_y==round(y))+1,find(map_z==round(z))]

x=find(map_x==round(xx));
y=find(map_y==round(yy));
z=find(map_z==round(zz));

try
    %     if map(x,y+max_ptp,z) || map(x,y,z) || map(x,y-max_ptp,z) ||  map(x-max_ptp,y+max_ptp,z) || map(x-max_ptp,y,z) || map(x-max_ptp,y-max_ptp,z) ||  map(x+max_ptp,y+max_ptp,z) || map(x+max_ptp,y,z) || map(x+max_ptp,y-max_ptp,z)
    %         inobs=1;
    %     end
    
    if ~map(x,y+max_ptp,z) && ~map(x,y,z) && ~map(x,y-max_ptp,z-max_ptp)
        if  ~map(x-max_ptp,y+max_ptp,z) && ~map(x-max_ptp,y,z) && ~map(x-max_ptp,y-max_ptp,z-max_ptp) %%%%%%% z-max_ptp
            if  ~map(x+max_ptp,y+max_ptp,z) && ~map(x+max_ptp,y,z) && ~map(x+max_ptp,y-max_ptp,z-max_ptp)
                
                if ~map(x,y+max_ptp,z) && ~map(x,y,z) && ~map(x,y-max_ptp,z)
                    if  ~map(x-max_ptp,y+max_ptp,z) && ~map(x-max_ptp,y,z) && ~map(x-max_ptp,y-max_ptp,z) %%%%%%% z
                        if  ~map(x+max_ptp,y+max_ptp,z) && ~map(x+max_ptp,y,z) && ~map(x+max_ptp,y-max_ptp,z)
                            
                            if ~map(x,y+max_ptp,z) && ~map(x,y,z) && ~map(x,y-max_ptp,z+max_ptp)
                                if  ~map(x-max_ptp,y+max_ptp,z) && ~map(x-max_ptp,y,z) && ~map(x-max_ptp,y-max_ptp,z+max_ptp) %%%%%%% z+max_ptp
                                    if  ~map(x+max_ptp,y+max_ptp,z) && ~map(x+max_ptp,y,z) && ~map(x+max_ptp,y-max_ptp,z+max_ptp)
                                        inobs=0;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    
catch
end

end