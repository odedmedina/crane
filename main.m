clear all; close all; % % % % % % % % % % % % % crane [length = 47, height=48]

global l2 crane_l in_move_damping last_move p slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance as ptp_counter
global  damp_move_times angle_limits real_angle map map_x map_y map_z crane_h ax theta ay vr_max vl_d_max vl_u_max vs_max end_config AdaptationLayer r_final_destination use_damp_move

map_number=1;  % G1/G2 & map1/map2

% load('damp_time_surf.mat');
load('damp_move_times'); load(['map' num2str(map_number) '.mat']);load(['G' num2str(map_number) '.mat']);  % G1/G2.mat or map1/map2.mat


end_config=[30 0 36];
end_config=[10 -10 10];
end_config=[45 -3 27];


%
% % % % % % % % % % % % % % % % % % % % % % Preferences
AdaptationLayer=1;
time_step=0.1; % between udp read
slow_factor=2;
distance=1; %to damp
plot_ptp=0;
use_damp_move=1;
in_move_damping=0;
angle_limits_flag=0;
try
    u=connectToCrane2;
catch
    comfix; u=connectToCrane2;
end
crane_write(0,0,0,1);


% % % % % % % % % % % % % % % % % % % % % % Crane Parameters

% crane_h=48; l2=12; crane_l=49.5; as=0.0126; ax=0.372; ay=1.85; vs_max=0.079*0.5; vr_max=1.93; vl_d_max=1.73;vl_u_max=1.064; angle_limits=[-720 720];
read_crane_parameters

% % % % % % % % % % % % % % % % % % % % % % Start values
ptp_counter=1;  ptp_vec=[];
r_final_destination=sqrt(end_config(1)^2+end_config(2)^2);

if end_config(3)>crane_h-l2
    end_config(3)=crane_h-l2;
end

tic

read_and_fix;
crane_write(0,0,0,1);
crane_write(end_config(1),end_config(2),end_config(3),2);

if map_check(x,y,z)
    tts('Start Point Error')
    disp('Start Point Error')
    return
end
if map_check(end_config(1),end_config(2),end_config(3))
    tts('End Point Error')
    disp('End Point Error')
    return
end


nexttile; %%%%%%%%%%%% Graphics
plot3(Px(1,:),Px(2,:),Px(3,:),'.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal;

surf(map_y,map_x,map');
plot3(end_config(1),end_config(2),end_config(3),'g*','markersize',10);
colormap([1 1 1;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5])

movegui([900 350]);
% % % draw crain
plot3([-0.5 -0.5],[0 0],[0 crane_h+5],'linewidth',10,'color',[0.8500, 0.3250, 0.0980]) %mast
plot3([-15 60],[0 0],[0 0],'linewidth',3,'color','black') %ground


[G,G_eff,G_slow,Px]=complete_G(G,G_eff,Px); %%%%%%%%%%%%%%%%%%%% complete_G

[dist,path,pred] = graphshortestpath(G_eff,1,2);
[dist_slow,path_slow,pred_slow] = graphshortestpath(G_slow,1,2);

dist=0;
for i=1:length(path)-1
    dist=dist+G(path(i),path(i+1));
end


slow_flag=0;
if dist_slow<dist
    dist=dist_slow;path=path_slow;pred=pred_slow;
    slow_flag=1;
    fprintf('\nSlow Movement Was Chosen\n\n')
end

for j=1:length(path)-1 %print the path and the times
    lineplot([Px(:,path(j))'],[Px(:,path(j+1))'],1)
    %     text(Px(1,path(j+1))',Px(2,path(j+1))',Px(3,path(j+1))',['\leftarrow ' num2str(G(path(j),path(j+1)),3) ''],'Color','red','FontSize',12)
end
% text(37,0,58,['total time ' num2str(dist,4) ' sec'],'Color','red','FontSize',12)

if dist>1000 || dist==0
    tts('can''t find path')
    disp('can''t find path')
    return
end


read_and_fix;

% movment
disp(['Calculation time is ' num2str(round(toc,1)) ' seconds.'])
fprintf(['Estimated time is ' num2str(round(dist,1)) ' seconds.\n\n'])

tic
last_move=0;

for j=2:length(path)-1
    if j==length(path)-1 || (Px(1,path(j))==Px(1,path(j+1)) &&  j==length(path)-2) && ~slow_flag
        last_move=1;
    end
    moveit(Px(1,path(j)),Px(2,path(j)),Px(3,path(j)));
end


crane_write(0,0,0,1);
if slow_flag
    moveit(Px(1,path(end)),Px(2,path(end)),Px(3,path(end)));
    vortex_damp;
else
    vortex_damp;
    %  moveit(Px(1,path(j)),Px(2,path(j)),Px(3,path(j)));
    
    read_and_fix
    while abs(z-end_config(3))>1
        
        crane_write(0,sign(end_config(3)-z),0,1);
        plot_load
        read_and_fix
        
        
    end
    
    
end

crane_write(0,0,0,1);

elapsed=toc;
disp(['Elapsed time is ' num2str(round(toc,1)) ' seconds.'])

fprintf(['  Error is ' num2str(round((elapsed-dist)*100/elapsed,1)) '%%.\n'])
text(37,0,58,['Total time ' num2str(round(toc,2)) ' seconds'],'Color','red','FontSize',12)
tts('mission accomplished')

if plot_ptp
    pause(3)
    nexttile
    t1=linspace(0,toc,length(ptp_vec));
    plot(t1,ptp_vec);grid on;xlabel('t [sec]');ylabel('ptp [m]');
    save('ptp.mat','t1','ptp_vec')
end
if angle_limits_flag
    disp(['Slew angle close to limit'])
end
