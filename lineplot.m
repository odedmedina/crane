function [] = lineplot(p1,p2,color)

global map map_x map_y map_z  roof angle max_ptp vr_max vl_d_max vl_u_max omega_max crane_h;

step=0.5;



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
    interp_r(j)=r1+sign(r2-r1)*(j-1)*vr_max*step;
    if abs(interp_r(j)-r2)<vr_max*step*0.5;
        break
    end
end

for j=1:10000
    interp_angle(j)=angle1+sign(angle2-angle1)*(j-1)*omega_max*step;
    if abs(interp_angle(j)-angle2)<omega_max*step*0.5;
        break
    end
end

for j=1:10000
    interp_z(j)=z1+sign(z2-z1)*(j-1)*vz_max*step;
    if abs(interp_z(j)-z2)<vz_max*step*0.5
        break
    end
end

intevals=max([length(interp_r) length(interp_angle) length(interp_z)]);

for j=length(interp_r):intevals
    interp_r(j)=r2;
end
for j=length(interp_angle):intevals
    interp_angle(j)=angle2;
end
for j=length(interp_z):intevals
    interp_z(j)=z2;
end

if color==1
plot3(interp_r.*cos(interp_angle),interp_r.*sin(interp_angle),interp_z,'g','linewidth',3)
end
if color==2
    plot3(interp_r.*cos(interp_angle),interp_r.*sin(interp_angle),interp_z,'r','linewidth',3)
end
% xlabel('x');ylabel('y');zlabel('z')
end


