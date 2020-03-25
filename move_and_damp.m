import java.awt.Robot;
import java.awt.event.*;
clear all; close all;clc; % % % % % % % % % % % % % crane [length = 47, height=48]

global theta_dot in_move_damping last_move slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance alpha ptp_counter
global  map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max omega_max end_config ptp ptp_temp
 
ax=0.77; vr_max=1.92;
ptp_counter=1;
time_step=0.1;
t1_vec=[];
ptps_vec=[];
hroot=groot; mouse = Robot;

set(groot,'PointerLocation',[2695,210]) %Play position
pause(0.1)
mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end
pause(0.25)
set(groot,'PointerLocation',[2720,210]) %Stop position
mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
pause(0.25)

for i=1:1
set(groot,'PointerLocation',[2695,210]) %Play position
pause(0.1)
mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
pause(4)

% t1=4*rand;
t1=4;
t1_vec=[t1 t1_vec]
crane_write(1,0,0,1)
pause(t1)    
crane_write(0,0,0,1)
theta=-1;
while theta<0
    read_and_fix
end
theta_dot=1;

pause(0.25*2*pi*sqrt(l/9.81)-ptp_temp(end)/vr_max)
% pause(0.4)
% while theta_dot>0
%     read_and_fix
% %     theta_dot
% end

crane_write(1,0,0,1)
pause(ptp_temp(end)/vr_max)
crane_write(0,0,0,1)
% pause(6)

    read_and_fix

% ptps_vec=[ptp_temp(end) ptps_vec]
% set(groot,'PointerLocation',[2720,210]) %Stop position
% mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
% pause(0.25)

end
