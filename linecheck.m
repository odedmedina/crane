function [isok] = linecheck(p1,p2)

global map map_x map_y map_z  roof angle max_ptp;

intervals=50;

% if abs(p2(1)-p1(1))<1 || abs(p2(2)-p1(2))<1
if norm(p2-p1)<1.5
    isok= 0 ;
    return
end

isok=1;

interp_x=linspace(p1(1),p2(1),intervals);
interp_y=linspace(p1(2),p2(2),intervals);
interp_z=linspace(p1(3),p2(3),intervals);


temp=max_ptp;
max_ptp=0;
for j=1:intervals
    
   if map_check(interp_x(j),interp_y(j),interp_z(j))
       
        isok=0;
        return
    end
end


max_ptp=temp;


end


