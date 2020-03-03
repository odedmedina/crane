global l theta theta_dot ptp phi phi_dot ptp_s


g=9.81;

theta_max=acos(cos(theta)-0.5*l*theta_dot^2/g);
ptp_temp(ptp_counter+1)=l*sin(theta_max);
ptp_counter=mod(ptp_counter+1,7);
ptp=mean(ptp_temp);


phi_max=acos(cos(phi)-0.5*l*phi_dot^2/g);
ptp_temp_s(ptp_counter+1)=l*sin(phi_max);
ptp_s=mean(ptp_temp_s);
