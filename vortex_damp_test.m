import java.awt.Robot;
import java.awt.event.*;
close all;clear all;
global time_step distance alpha ptp_counter crane_h ax ay vr_max vl_d_max vl_u_max omega_max

times=1;
heights=[36:27];
y_locations=[610 590 570 550 530 425 505 485 465 445 405 385 360 340 320 300 275 255 230 210];

hroot=groot; mouse = Robot;

time_step=0.1; % between udp read
crane_h=48; alpha=0.117; ax=0.77; ay=1.85;
omega_max=0.0794*0.5; vr_max=1.92; vl_d_max=1.735;vl_u_max=1.07;
ptp_counter=1;
distance=2; %to damp

set(groot,'PointerLocation',[2265,100]) %Play position
pause(0.1)
mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end

pause(0.25)
set(groot,'PointerLocation',[2350,100]) %Stop position
mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
pause(0.25)

for i=1:length(y_locations)
    
    set(groot,'PointerLocation',[1620,y_locations(i)]) % configurations
    pause(0.001)
    mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
    pause(0.25) 
    set(groot,'PointerLocation',[2300,770]) %Actice position
    mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
    pause(0.25)
    
    for j=1:times
        set(groot,'PointerLocation',[2265,100]) %Play position
        pause(0.001)
        mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
        
        tic
        vortex_damp
% pause(j/2)
        time_vec(j)=toc;
        
        set(groot,'PointerLocation',[2350,100]) %Stop position
        pause(0.001)
        mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
        pause(0.25)
        
        
    end
    time_vec_means(i)=mean(time_vec)
    time_vec=[];
    
    set(groot,'PointerLocation',[2300,750]) %Deactice position
     pause(0.25)
    mouse.mousePress(InputEvent.BUTTON1_MASK); pause(0.001);mouse.mouseRelease(InputEvent.BUTTON1_MASK); % left click press & release
    pause(0.25)
end

save('vortex_damp_results.mat','time_vec_means','heights')

