clear all; close all; % % % % % % % % % % % % % crane [length = 47, height=48]

global theta_dot in_move_damping last_move slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance alpha ptp_counter
global  map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max omega_max end_config ptp ron ptp_temp AdaptationLayer
 
distance=1;crane_h=48;
ax=100; vr_max=1.92;
ptp_counter=1;
time_step=0.1;
AdaptationLayer=0;
t1_vec=[];
ptps_vec=[];

try
    u=connectToCrane2;
catch
    comfix
    u=connectToCrane2;
end

t1=4;
crane_write(1,0,0,1)
pause(t1)    
crane_write(0,0,0,1)
theta=-1;
while theta<0
    read_and_fix
end

% t_acc=vr_max/ax;
% 
%     time_for_ptp=sqrt(2*ptp_temp(end)/ax);
% if time_for_ptp>t_acc
%    time_for_ptp=(ptp_temp(end)-0.5*ax*t_acc^2)/vr_max+t_acc;
% end
%     
ptp_temp(end)
time_for_ptp=ptp_temp(end)/vr_max*1 % *0.7

pause((0.25*2*pi*sqrt(l/9.81)-time_for_ptp)*1)
crane_write(0.5,0,0,1)
pause(time_for_ptp*0.5)
crane_write(1,0,0,1)
pause(time_for_ptp*1)
crane_write(0,0,0,1)

pause(4)
read_and_fix
ptp_temp(end)
% vortex_damp