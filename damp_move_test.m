function damp_move_test(x)
global vortex_damp_flag last_time in_move_damping use_damp_move r_final_destination angle_destination slow_flag ptp_temp last_move ptp distance end_config

r_final_destination=x; slow_flag=0; angle_destination=700; last_move=1;
distance=1; in_move_damping=0;


% use_damp_move=0;
tic

% end_config=[x,0,30];
moveit(end_config(1),end_config(2),end_config(3))


read_and_fix
ptp;

if vortex_damp_flag
vortex_damp
end

last_time=toc;

% pause(4)
read_and_fix
% disp(ptp_temp(end))