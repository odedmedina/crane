clear all; close all; % % % % % % % % % % % % % crane [length = 47, height=48]

global l2 crane_l in_move_damping last_move p slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance alpha ptp_counter
global  map map_x map_y map_z crane_h ax theta ay vr_max vl_d_max vl_u_max omega_max end_config AdaptationLayer r_final_destination use_damp_move

% load('damp_time_surf.mat');
load('damp_move_times');
load('map1.mat');load('G1.mat');  % G1/G2.mat or map1/map2.mat


end_config=[+45 0 28];

% end_config=[10 -10 5];
end_config=[8 -0 30];
%
% % % % % % % % % % % % % % % % % % % % % % Preferences
AdaptationLayer=1;
time_step=0.1; % between udp read
slow_factor=1.7;
distance=1; %to damp
plot_ptp=0;
use_damp_move=1;
in_move_damping=0;

try
    u=connectToCrane2;
catch
    comfix; u=connectToCrane2;
end
crane_write(0,0,0,1);


% % % % % % % % % % % % % % % % % % % % % % Crane Parameters

% crane_h=temp1(8); crane_l=temp1(9); l2=temp1(10); vr_max=temp1(11);  ax=temp1(12); vl_u_max=temp1(13); vl_d_max=temp1(14); ay=temp1(15); omega_max=temp1(16)*0.5;  alpha=temp1(17);
crane_h=48; l2=10; crane_l=49.5; alpha=0.0126; ax=14; ay=1.85; omega_max=0.079*0.5; vr_max=1.93; vl_d_max=1.73;vl_u_max=1.064;


% % % % % % % % % % % % % % % % % % % % % % Start values
ptp_counter=1;  ptp_vec=[];
r_final_destination=sqrt(end_config(1)^2+end_config(2)^2);

if end_config(3)>crane_h-l2
    end_config(3)=crane_h-l2;
end


tic


read_and_fix;
if map_check(x,y,z)
    tts('Start Point Error')
    return
end



r_final_destination=sqrt(end_config(1)^2+end_config(2)^2);
angle_final=atan2(end_config(2),end_config(1))+2*pi;
angle_start=atan2(y,x)+2*pi;
angle_mid=(angle_start+angle_final)/2;

temp1=max(angle_start,angle_final)-min(angle_start,angle_final);
temp2=min(angle_start,angle_final)+2*pi-max(angle_start,angle_final);
angle_range=min(temp1,temp2); %diff between the angles
angle_range=2*angle_range*180/pi*0.5+40;

vec_mid=[cos(angle_mid) sin(angle_mid) 0];




crane_write(0,0,0,1);
crane_write(end_config(1),end_config(2),end_config(3),2);


nexttile; %%%%%%%%%%%% Graphics
plot3(Px(1,:),Px(2,:),Px(3,:),'.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal;
% % % draw obs
% [obsx]=makepoints2(100000);
% plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')
surf(map_y,map_x,map');
colormap([1 1 1;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5;0.5 0.5 0.5])

movegui([900 350]);
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
        
        vec_check=Px(:,k); vec_check(3)=0; vec_check=vec_check/norm(vec_check);
        if acosd(vec_mid*vec_check)<angle_range  %% check only if in the angle range (calc time saver)
            
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            isok=linecheck(Px(:,j)',Px(:,k)');
            if  isok && j~=k && k~=2  && abs(Px(1,j)-Px(1,k))>0.5 && abs(Px(2,j)-Px(2,k))>0.5% not connected and not above to end point
                
                G(j,k)=t_max; %time if the path is clear, 0 if not
                G_slow(j,k)=t_max*slow_factor;
                G_eff(j,k)=t_max+norm([Px(:,j)'-Px(:,k)']);
                
            elseif isok && j~=k && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5 && k==2 % connected and above the end point
                
                
                %             ind=find(l_vec==round(-Px(3,j)+crane_h));
                %             t_damp_l=results_mean(ind,:,:);
                
                ind=round(crane_h-Px(3,j));
                if ind>length(damp_move_times)
                    ind=length(damp_move_times);
                end
                
                G(j,k)=t_max+damp_move_times(ind);
                G_slow(j,k)=t_max*slow_factor;
                G_eff(j,k)=t_max+damp_move_times(ind);
                
            elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
                G_slow(j,k)=t_max*slow_factor;
            end
        end
    end
end

for j=1:N
    for k=1:new_point_count+2
        
        vec_check=Px(:,j); vec_check(3)=0; vec_check=vec_check/norm(vec_check);
        if acosd(vec_mid*vec_check)<angle_range %% check only if in the angle range (calc time saver)
            
            
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            isok=linecheck(Px(:,j)',Px(:,k)');
            if  isok && j~=k && k~=2  && abs(Px(1,j)-Px(1,k))>0.5 && abs(Px(2,j)-Px(2,k))>0.5% not connected and not above to end point
                
                G(j,k)=t_max; %time if the path is clear, 0 if not
                G_slow(j,k)=t_max*slow_factor;
                G_eff(j,k)=t_max+norm([Px(:,j)'-Px(:,k)']);
                
            elseif isok && j~=k && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5 && k==2 % connected and above the end point
                
                
                %             ind=find(l_vec==round(-Px(3,j)+crane_h));
                %             t_damp_l=results_mean(ind,:,:);
                %
                %             G(j,k)=t_max+min(t_damp_l);
                %             G_slow(j,k)=t_max*slow_factor;
                %             G_eff(j,k)=t_max+min(t_damp_l);
                
                ind=round(crane_h-Px(3,j));
                if ind>length(damp_move_times)
                    ind=length(damp_move_times);
                end
                
                G(j,k)=t_max+damp_move_times(ind);
                G_slow(j,k)=t_max*slow_factor;
                G_eff(j,k)=t_max+damp_move_times(ind);
                
            elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
                G_slow(j,k)=t_max*slow_factor;
            end
        end
    end
end

G_eff=sparse(G_eff); %%%%%%%%%%%%%%% G_eff=sparse(G_eff) for shorter path
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
    disp('                  Slow Movement Was Chosen')
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

toc; elapsed=toc;

fprintf(['  Error is ' num2str(round((elapsed-dist)*100/elapsed,1)) '%%.\n'])
text(37,0,58,['Total Time ' num2str(round(toc,2)) ' seconds'],'Color','red','FontSize',12)
tts('mission accomplished')

if plot_ptp
    pause(3)
    nexttile
    t1=linspace(0,toc,length(ptp_vec));
    plot(t1,ptp_vec);grid on;xlabel('t [sec]');ylabel('ptp [m]');
    save('ptp.mat','t1','ptp_vec')
end
