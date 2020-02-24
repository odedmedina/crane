function [] = interval_moveit(desired_x,desired_y,desired_z)

global time_step u x  l crane_h y;

% flushinput(u);temp1=fread(u,6,'double');
%     pause(time_step);
%     flushinput(u);temp2=fread(u,6,'double');
%     fix_inputs(temp1,temp2);clearvars temp1 temp2
    
l_destination=crane_h-desired_z;

intervals(1)=ceil(abs(x-desired_x));
intervals(2)=ceil(abs(y-desired_y));
intervals(3)=ceil(abs(l-l_destination));

intervals=min(intervals)+1;

intervals=1;

interp_x=linspace(x,desired_x,intervals);
interp_y=linspace(y,desired_y,intervals);
interp_z=linspace(l,l_destination,intervals);


for j=1:intervals
    
    desired_x2=interp_x(j) ;
    desired_angle2=interp_y(j) ;
    desired_z2=interp_z(j) ;
    moveit(desired_x2,desired_angle2,desired_z2);
    
end
% fwrite(u,[ax,-ay,0],'double');
% tts('arived')
end

