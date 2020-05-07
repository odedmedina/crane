function fix_inputs(temp1,temp2)

global real_angle ptp_counter vr_vec r x y l vr hook_x angle theta dtheta theta_dot  time_step hook_r hook_y z crane_h omega phi phi_dot

l(1)=temp1(1); r(1)=temp1(2); angle(1)=temp1(3); hook_x(1)=temp1(4); hook_y(1)=temp1(5); hook_z(1)=temp1(6);
l(2)=temp2(1); r(2)=temp2(2); angle(2)=temp2(3); hook_x(2)=temp2(4); hook_y(2)=temp2(5); hook_z(2)=temp2(6);
t1=temp1(7); t2=temp2(7);
time_step=t2-t1;
real_angle=round(angle(2)*180/pi);


dtheta(1)=atan2(hook_y(1),hook_x(1))-angle(1); % The difference between the hook and jib angles
dtheta(2)=atan2(hook_y(2),hook_x(2))-angle(2);

hook_r(1)=sqrt(hook_x(1)^2+hook_y(1)^2)*cos(dtheta(1));
hook_r(2)=sqrt(hook_x(2)^2+hook_y(2)^2)*cos(dtheta(2));

hook_side(1)=sqrt(hook_x(1)^2+hook_y(1)^2)*sin(dtheta(1));
hook_side(2)=sqrt(hook_x(2)^2+hook_y(2)^2)*sin(dtheta(2));



x(1)=r(1)*cos(angle(1));
y(1)=r(1)*sin(angle(1));
x(2)=r(2)*cos(angle(2));
y(2)=r(2)*sin(angle(2));


theta(1)=asin((hook_r(1)-r(1))/l(1));
theta(2)=asin((hook_r(2)-r(2))/l(2));

phi(1)=asin((hook_side(1))/l(1));
phi(2)=asin((hook_side(2))/l(2));


vr_temp=(r(2)-r(1))/time_step;
theta_dot_temp=(theta(2)-theta(1))/time_step;
omega_temp=(angle(2)-angle(1))/time_step;
phi_dot_temp=(phi(2)-phi(1))/time_step;


vr_vec(ptp_counter+1)=vr_temp;
vr=mean(vr_vec);

theta_dot_vec(ptp_counter+1)=theta_dot_temp;
theta_dot=mean(theta_dot_vec);

omega_vec(ptp_counter+1)=omega_temp;
omega=mean(omega_vec);

phi_dot_vec(ptp_counter+1)=phi_dot_temp;
phi_dot=mean(phi_dot_vec);



theta=theta(2);x=x(2);y=y(2);r=r(2);l=l(2);angle=angle(2);dtheta=dtheta(2);phi=phi(2);
z=crane_h-l;


if angle<0
    angle=angle+2*pi;
end
while angle>2*pi
    angle=angle-2*pi;
end


end

