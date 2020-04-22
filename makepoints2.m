function [Px] = makepoints2(N)
% makes random points
global map map_x map_y map_z x l crane_h end_config angle l2

Px=[];

while length(Px)<N-1
  
    
    
   
    zz=(crane_h-l2)*rand;
     rr=50*rand;
    tt=rand*2*pi;
    
    
    %      check
%     if map(find(map_x==round(rr*cos(tt))),find(map_y==round(rr*sin(tt))),find(map_z==round(zz)))
        if map(find(map_x==round(rr*cos(tt))),find(map_y==round(rr*sin(tt))))>round(zz)
        Px=[Px,[rr*cos(tt);rr*sin(tt);zz]];
    end
    
end
end

