function [Px] = makepoints2(N)
% makes random points
global map map_x map_y map_z x l crane_h end_config angle

Px=[];

while length(Px)<N-1
  
    
    
   
    zz=(crane_h-10)*rand;
     rr=50*rand;
    tt=rand*2*pi;
    
    
    %      check
    if map(find(map_x==round(rr*cos(tt))),find(map_y==round(rr*sin(tt))),find(map_z==round(zz)))
        Px=[Px,[rr*cos(tt);rr*sin(tt);zz]];
    end
    
end
end

