close all;clear all;clc; % % % % % % % % % % % % % crane [length = 47, height=48]
tic

global max_ptp ptp_vec u time_step r x l y z angle l2 roof distance alpha omega_max angle_destination map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max end_config
load('damp_time_surf.mat');load('map.mat');load('G.mat');

end_config=[35 -25 20]; %% X  Y  Z

time_step=0.1; % between udp read
max_ptp=2;

l2=6.5; crane_h=46; N=230 ;
alpha=0.117; ax=0.77; ay=1.85;
omega_max=0.0794*0.5; vr_max=1.92; vl_d_max=1.735;vl_u_max=1.07;

distance=2; %to damp
roof=1; %distance from the roof

try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end
read_and_fix;
fwrite(u,[0,0,0,1],'double');
fwrite(u,[end_config 2],'double');
read_and_fix

nexttile;ptp_vec=[];

% [Px,N]=makepoints(N);


plot3(Px(1,:),Px(2,:),Px(3,:),'.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal
% % % draw obs 
[obsx]=makepoints2(100000);
plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')

% % % draw crain
plot3([-0.5 -0.5],[0 0],[0 crane_h+5],'linewidth',10,'color',[0.8500, 0.3250, 0.0980]) %mast
plot3([-15 60],[0 0],[0 0],'linewidth',3,'color','black') %ground

% % % creates G matrix with time values
% G=zeros(N);
new_point_count=0;
for i=1:40
    if ~map_check(end_config(1),end_config(2),i)
        Px=[[end_config(1);end_config(2);i],Px];
        new_point_count=new_point_count+1;
    end
end
Px=[[r*cos(angle);r*sin(angle);z] [end_config(1);end_config(2);end_config(3)] Px ];

N=length(Px);
temp=zeros(N);
temp(N-250+1:end,N-250+1:end)=G;
G=temp;
for j=1:new_point_count+2
    for k=1:N
        
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k && k~=2 
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            G(j,k)=t_max; %time if the path is clear, 0 if not
        
        elseif isok && j~=k && k==2 && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5  % connected and above the end point
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            
            ind=find(l_vec==round(-Px(3,j)+crane_h));
            t_damp_l=results_mean(ind,:,:);
            
            G(j,k)=t_l+min(t_damp_l);
%         elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
%             G(j,k)=1000;
        end
    end
end

for j=1:N
    for k=1:new_point_count+2
        
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k && k~=2 
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            G(j,k)=t_max; %time if the path is clear, 0 if not
        
        elseif isok && j~=k && k==2 && abs(Px(1,j)-Px(1,k))<0.5 && abs(Px(2,j)-Px(2,k))<0.5  % connected and above the end point
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            
            ind=find(l_vec==round(-Px(3,j)+crane_h));
            t_damp_l=results_mean(ind,:,:);
            
            G(j,k)=t_l+min(t_damp_l);
%         elseif isok && j~=k && (abs(Px(1,j)-Px(1,k))>0.5 || abs(Px(2,j)-Px(2,k))>0.5) % connected and not above the end point
%             G(j,k)=1000;
        end
    end
end

G=sparse(G);
[dist,path,pred] = graphshortestpath(G,1,2);


for j=1:length(path)-1 %print the path and the times
    plot3([Px(1,path(j)) Px(1,path(j+1))],[Px(2,path(j)) Px(2,path(j+1))],[Px(3,path(j)) Px(3,path(j+1))],'g','linewidth',3)
       text(Px(1,path(j+1))',Px(2,path(j+1))',Px(3,path(j+1))',['\leftarrow ' num2str(G(path(j),path(j+1)),3) ''],'Color','red','FontSize',12)    
end
text(37,0,58,['total time ' num2str(dist,4) ' sec'],'Color','red','FontSize',12)

if dist>1000
    return
end


read_and_fix;

% movment 
toc
tic
for j=2:length(path)-1
    interval_moveit(Px(1,path(j)),Px(2,path(j)),Px(3,path(j)));
end

vortex_damp;
x=r*cos(angle_destination);y=r*sin(angle_destination);
interval_moveit(x,y,Px(3,path(end)));
toc
['Estimated time is ' num2str(round(dist,1)) ' seconds.']

 fwrite(u,[0,0,0,1],'double');
tts('mission accomplished')

% 
% nexttile
%   t=linspace(0,toc,length(ptp_vec));
%   plot(t,ptp_vec);grid on;xlabel('t [sec]');ylabel('ptp [m]');
% 
