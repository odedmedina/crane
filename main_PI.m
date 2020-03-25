close all;clear all;clc; % % % % % % % % % % % % % crane [length = 47, height=48]


global in_move_damping slow_flag  last_move slow_factor max_ptp ptp_vec u time_step r x l y z angle l2  distance alpha ptp_counter
global angle_destination map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max omega_max end_config
load('damp_time_surf.mat');load('map_conf.mat');

end_config=[45 0 25];
% end_config=[32 23 37];
% end_config=[23 35 4];
% end_config=[0 -7 5];

in_move_damping=1;
time_step=0.1; % between udp read
ptp_counter=0;
Px=[];
G=[];
l2=6.5; crane_h=48;
alpha=0.117; ax=0.77; ay=1.85;
omega_max=0.0794*0.5; vr_max=1.92; vl_d_max=1.735;vl_u_max=1.07;
slow_flag=0; last_move=1;
distance=1.5; %to damp


try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end
read_and_fix;
fwrite(u,[0,0,0,1],'double');
fwrite(u,[end_config 2],'double');
start_config=[x y z];
nexttile;ptp_vec=[];


[obsx]=makepoints2(100000);
plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal; 
% % % draw obs


% % % draw crain
plot3([-0.5 -0.5],[0 0],[0 crane_h+5],'linewidth',10,'color',[0.8500, 0.3250, 0.0980]) %mast
plot3([-15 60],[0 0],[0 0],'linewidth',3,'color','black') %ground

% % % creates G matrix with time values
read_and_fix
P(1,:)=[x,y,z];
P(2,:)=[x,y,crane_h-10];
if sqrt(start_config(1)^2+start_config(2)^2)>sqrt(end_config(1)^2+end_config(2)^2) 
P(3,:)=[sqrt(end_config(1)^2+end_config(2)^2)*cos(angle),sqrt(end_config(1)^2+end_config(2)^2)*sin(angle),crane_h-10];
    P(4,:)=[sqrt(end_config(1)^2+end_config(2)^2)*cos(atan2(end_config(2),end_config(1))),sqrt(end_config(1)^2+end_config(2)^2)*sin(atan2(end_config(2),end_config(1))),crane_h-10];

else
P(3,:)=[r*cos(atan2(end_config(2),end_config(1))),r*sin(atan2(end_config(2),end_config(1))),crane_h-10];
P(4,:)=[end_config(1),end_config(2),crane_h-10];
end

P(5,:)=[end_config(1),end_config(2),end_config(3)];

for i=1:4  %print the path and the times
    lineplot(P(i,:),P(i+1,:),1)
    [t_max, t_r, t_l, t_s]=timecalc(P(i,:),P(i+1,:));
    if i==4
        ind=find(l_vec==10);
        t_damp_l=min(results_mean(ind,:,:));
        path(i)=t_max+t_damp_l;
    else
        path(i)=t_max;
    end
%     text(P(i+1,1),P(i+1,2),P(i+1,3),['\leftarrow ' num2str(round(path(i),2)) ''],'Color','red','FontSize',12)
end
% text(37,0,58,['total time ' num2str(sum(path)) ' sec'],'Color','red','FontSize',12)


read_and_fix;

% movment
tic

for i=2:4
moveit(P(i,1),P(i,2),P(i,3));
read_and_fix
end
vortex_damp;
fwrite(u,[0,0,0,1],'double');
while abs(z-end_config(3))>1
    read_and_fix
    fwrite(u,[0,sign(end_config(3)-z),0,1],'double');
end

fwrite(u,[0,0,0,1],'double');

toc
text(37,0,58,['Total Time ' num2str(round(toc,2)) ' seconds'],'Color','red','FontSize',12)


tts('mission accomplished')
pause(3)

% 
% nexttile
  t1=linspace(0,toc,length(ptp_vec));
  ptp1=ptp_vec;
  ptp_vec=[];
%   plot(t,ptp_vec);grid on;xlabel('t [sec]');ylabel('ptp [m]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=[];
in_move_damping=0;

end_config=([10 -10 5]);
crane_write(10,-10,2,2);

read_and_fix
P(1,:)=[x,y,z];
P(2,:)=[x,y,crane_h-10];
if sqrt(start_config(1)^2+start_config(2)^2)<sqrt(end_config(1)^2+end_config(2)^2) 
P(3,:)=[sqrt(end_config(1)^2+end_config(2)^2)*cos(angle),sqrt(end_config(1)^2+end_config(2)^2)*sin(angle),crane_h-10];
    P(4,:)=[sqrt(end_config(1)^2+end_config(2)^2)*cos(atan2(end_config(2),end_config(1))),sqrt(end_config(1)^2+end_config(2)^2)*sin(atan2(end_config(2),end_config(1))),crane_h-10];

else
P(3,:)=[r*cos(atan2(end_config(2),end_config(1))),r*sin(atan2(end_config(2),end_config(1))),crane_h-10];
P(4,:)=[end_config(1),end_config(2),crane_h-10];
end

P(5,:)=[end_config(1),end_config(2),end_config(3)];

for i=1:4  %print the path and the times
    lineplot(P(i,:),P(i+1,:),2)
    [t_max, t_r, t_l, t_s]=timecalc(P(i,:),P(i+1,:));
    if i==4
        ind=find(l_vec==10);
        t_damp_l=min(results_mean(ind,:,:));
        path(i)=t_max+t_damp_l;
    else
        path(i)=t_max;
    end
%     text(P(i+1,1),P(i+1,2),P(i+1,3),['\leftarrow ' num2str(round(path(i),2)) ''],'Color','red','FontSize',12)
end
% text(37,0,58,['total time ' num2str(sum(path)) ' sec'],'Color','red','FontSize',12)


read_and_fix;

% movment
tic

for i=2:4
moveit(P(i,1),P(i,2),P(i,3));
read_and_fix
end

fwrite(u,[0,0,0,1],'double');
while abs(z-end_config(3))>1
    read_and_fix
    fwrite(u,[0,sign(end_config(3)-z),0,1],'double');
end

fwrite(u,[0,0,0,1],'double');

toc
text(37,0,30,['Total Time ' num2str(round(toc,2)) ' seconds'],'Color','red','FontSize',12)


tts('mission accomplished')

% 
% nexttile
  t2=linspace(0,toc,length(ptp_vec));
  ptp2=ptp_vec;
  ptp_vec=[];
  
  t=[t1 t1(end)+10 t2+t1(end)+10];
%   plot(t,[ptp_vec1 ptp_vec1(end) ptp_vec2]);grid on;xlabel('t [sec]');ylabel('ptp [m]');
  
%
ptp_vec=[ptp1 ptp2];
save('ptp_HO','t','ptp_vec')