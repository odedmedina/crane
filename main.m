clear all; close all; % % % % % % % % % % % % % crane [length = 47, height=48]

global in_move_damping last_move slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance alpha ptp_counter
global  map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max omega_max end_config AdaptationLayer

load('damp_time_surf.mat');
load('map1.mat');load('G1.mat');  % G1/G2.mat or map1/map2.mat


% end_config=[xx yy zz];
% end_config=[45 10 25]; 
% end_config=[32 23 36];
% end_config=[40 -20 10]; 
end_config=[45 0 35];


% % % % % % % % % % % % % % % % % % % % % % Preferences
AdaptationLayer=0;
time_step=0.1; % between udp read
slow_factor=1.75;
distance=2; %to damp
plot_ptp=0;

% % % % % % % % % % % % % % % % % % % % % % Crane Parameters
crane_h=48; alpha=0.117; ax=0.77; ay=1.85; omega_max=0.0794*0.5; vr_max=1.92; vl_d_max=1.735;vl_u_max=1.07;

% % % % % % % % % % % % % % % % % % % % % % Start values
ptp_counter=1; in_move_damping=0; ptp_vec=[]; tic

try
u=connectToCrane2;
catch
    comfix
    u=connectToCrane2;
end

read_and_fix;
crane_write(0,0,0,1);
crane_write(end_config(1),end_config(2),end_config(3),2);
read_and_fix


nexttile; %%%%%%%%%%%% Graphics
plot3(Px(1,:),Px(2,:),Px(3,:),'.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal
% % % draw obs
[obsx]=makepoints2(100000);
plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')
% % % draw crain
plot3([-0.5 -0.5],[0 0],[0 crane_h+5],'linewidth',10,'color',[0.8500, 0.3250, 0.0980]) %mast
plot3([-15 60],[0 0],[0 0],'linewidth',3,'color','black') %ground
% % % creates G matrix with time values

N1=length(Px);
new_point_count=0;
for i=1:crane_h-12
    if ~map_check(end_config(1),end_config(2),i)
        Px=[[end_config(1);end_config(2);i],Px];
        new_point_count=new_point_count+1;
    end
end
Px=[[r*cos(angle);r*sin(angle);z] [end_config(1);end_config(2);end_config(3)] Px ];
N=length(Px);
temp1=zeros(N);temp2=zeros(N);
temp1(N-N1+1:end,N-N1+1:end)=G;
temp2(N-N1+1:end,N-N1+1:end)=G_eff;
G=temp1; G_eff=temp2; % less energy consumption

G_slow=G*slow_factor;
for j=1:new_point_count+2
    for k=1:N
        [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k && k~=2
           
            G(j,k)=t_max; %time if the path is clear, 0 if not
            G_slow(j,k)=t_max*slow_factor;
            G_eff(j,k)=t_max+norm([Px(:,j)'-Px(:,k)']);
            
        elseif isok && j~=k && k==2 && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5  % connected and above the end point
            
            
            ind=find(l_vec==round(-Px(3,j)+crane_h));
            t_damp_l=results_mean(ind,:,:);
            
            G(j,k)=t_l+min(t_damp_l);
            G_slow(j,k)=t_l*slow_factor;
            G_eff(j,k)=t_l+min(t_damp_l);
            
        elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
            G_slow(j,k)=t_max*slow_factor;
        end
    end
end

for j=1:N
    for k=1:new_point_count+2
        [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k && k~=2
            
            G(j,k)=t_max; %time if the path is clear, 0 if not
            G_slow(j,k)=t_max*slow_factor;
            G_eff(j,k)=t_max+norm([Px(:,j)'-Px(:,k)']);
            
        elseif isok && j~=k && k==2 && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5  % connected and above the end point
           
            
            ind=find(l_vec==round(-Px(3,j)+crane_h));
            t_damp_l=results_mean(ind,:,:);
            
            G(j,k)=t_l+min(t_damp_l);
            G_slow(j,k)=t_l*slow_factor;
            G_eff(j,k)=t_l+min(t_damp_l);
            
        elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
             G_slow(j,k)=t_max*slow_factor;
        end
    end
end

G_eff=sparse(G); %%%%%%%%%%%%%%% G_eff=sparse(G_eff) for shorter path
G_slow=sparse(G_slow);

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
end

for j=1:length(path)-1 %print the path and the times
    lineplot([Px(:,path(j))'],[Px(:,path(j+1))'],1)
%     text(Px(1,path(j+1))',Px(2,path(j+1))',Px(3,path(j+1))',['\leftarrow ' num2str(G(path(j),path(j+1)),3) ''],'Color','red','FontSize',12)
end
% text(37,0,58,['total time ' num2str(dist,4) ' sec'],'Color','red','FontSize',12)

if dist>1000 || dist==0
    tts('can''t find path')
    return
end


read_and_fix;

% movment
toc
tic
last_move=0;
for j=2:length(path)-1
    if j==length(path)-2
        last_move=1
    end
    moveit(Px(1,path(j)),Px(2,path(j)),Px(3,path(j)));
end


crane_write(0,0,0,1);
if slow_flag
    disp('                  Slow Movement Was Chosen')
    moveit(Px(1,path(end)),Px(2,path(end)),Px(3,path(end)));
    vortex_damp;
    else
vortex_damp;
%  moveit(Px(1,path(j)),Px(2,path(j)),Px(3,path(j)));

read_and_fix
while abs(z-end_config(3))>1
    read_and_fix
    crane_write(0,sign(end_config(3)-z),0,1);
end

    
end

crane_write(0,0,0,1);

toc; elapsed=toc;
disp(['Estimated time is ' num2str(round(dist,1)) ' seconds.'])
fprintf(['\nError is ' num2str(round((elapsed-dist)*100/elapsed,1)) '%%.\n'])
text(37,0,58,['Total Time ' num2str(round(toc,2)) ' seconds'],'Color','red','FontSize',12)
tts('mission accomplished')

if plot_ptp
nexttile
  t1=linspace(0,toc,length(ptp_vec));
  plot(t,ptp_vec);grid on;xlabel('t [sec]');ylabel('ptp [m]');
end
