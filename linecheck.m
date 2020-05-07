function [isok] = linecheck(p1,p2)

global map map_x map_y map_z  roof angle max_ptp vr_max vl_d_max vl_u_max vs_max crane_h ax ay as l2;

if p1(3)>crane_h-l2
    p1(3)=crane_h-l2;
end
if p2(3)>crane_h-l2
    p2(3)=crane_h-l2;
end
    
    
step=0.25;

if norm(p2-p1)<1.5 && norm(p2-p1)<0
    isok= 0 ;
    return
end

if p2(3)>p1(3)
    vz_max=vl_u_max;
else
    vz_max=vl_d_max;
end

isok=1;

r1=sqrt(p1(1)^2+p1(2)^2);
angle1=atan2(p1(2),p1(1));
z1=p1(3);
r2=sqrt(p2(1)^2+p2(2)^2);
angle2=atan2(p2(2),p2(1));
z2=p2(3);

if angle1<0
    angle1=angle1+2*pi;
end
if angle2<0
    angle2=angle2+2*pi;
end

while abs(angle2-angle1)>pi
    if angle2>angle1
        angle2=angle2-2*pi;
    else
        angle2=angle2+2*pi;
    end
end


for j=1:10000
    if abs(ax*(j-1)*step)<abs(vr_max)
        interp_r(j)=r1+0.5*ax*sign(r2-r1)*((j-1)*step)^2;
    else
        interp_r(j)=r1+sign(r2-r1)*(j-1)*vr_max*step;
    end
    
    if (interp_r(j)>r1 && interp_r(j)>r2) || (interp_r(j)<r1 && interp_r(j)<r2) || r1==r2
        break
    end
end
for j=1:10000    
    if abs(as*(j-1)*step)<abs(vs_max)
        interp_angle(j)=angle1+0.5*as*sign(angle2-angle1)*((j-1)*step)^2;
    else
        interp_angle(j)=angle1+sign(angle2-angle1)*(j-1)*vs_max*step;
    end
  
    if (interp_angle(j)>angle1 && interp_angle(j)>angle2) || (interp_angle(j)<angle1 && interp_angle(j)<angle2) || angle1==angle2
        break
    end
end

for j=1:10000
    
    if abs(ay*(j-1)*step)<abs(vz_max)
        interp_z(j)=z1+0.5*ay*sign(z2-z1)*((j-1)*step)^2;
    else
        interp_z(j)=z1+sign(z2-z1)*(j-1)*vz_max*step;
    end
    
    if (interp_z(j)>z1 && interp_z(j)>z2) || (interp_z(j)<z1 && interp_z(j)<z2) || z1==z2
        break
    end
end

intervals=max([length(interp_r) length(interp_angle) length(interp_z)]);

for j=length(interp_r):intervals
    interp_r(j)=r2;
end
for j=length(interp_angle):intervals
    interp_angle(j)=angle2;
end
for j=length(interp_z):intervals
    interp_z(j)=z2;
end

if intervals==10000
    a=0
end


for j=1:intervals
    
    if map_check(interp_r(j)*cos(interp_angle(j)),interp_r(j)*sin(interp_angle(j)),interp_z(j))
        
        isok=0;
        return
    end
end
%
% plot3(interp_r.*cos(interp_angle),interp_r.*sin(interp_angle),interp_z)
% xlabel('x');ylabel('y');zlabel('z')
end


