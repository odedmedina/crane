function Untitled(xx)
global end_config ptp_counter ptp_temp
ptp_counter=1;

end_config=[xx 0 25.5];

moveit(end_config(1)-0,end_config(2),end_config(3))
% vortex_damp
% pause(5)
% read_and_fix
% ptp_temp(end)

% %  al and as is changing with no reason