global l theta theta_dot ptp


g=9.81;

theta_max=acos(cos(theta)-0.5*l*theta_dot^2/g);
ptp=l*sin(theta_max);

