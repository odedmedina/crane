close all;clear all;clc; % % % % % % % % % % % % % crane [length = 47, height=48]
tic

global max_ptp ptp_vec u time_step x l y angle l2 roof distance alpha omega_max map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max end_config
load('map.mat');
max_ptp=2;

crane_h=46; N=300 ;
alpha=0.117; ax=0.77; ay=1.85;
omega_max=0.0794*0.5; vr_max=1.92; vl_d_max=1.735;vl_u_max=1.07;

distance=2; %to damp
roof=1; %distance from the roof


[Px,N]=makepoints(N);


plot3(Px(1,:),Px(2,:),Px(3,:),'.')
hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal
% % % draw obs 
[obsx]=makepoints2(100000);
plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')

% % % draw crain
plot3([-0.5 -0.5],[0 0],[0 crane_h+5],'linewidth',10,'color',[0.8500, 0.3250, 0.0980]) %mast
plot3([-15 60],[0 0],[0 0],'linewidth',3,'color','black') %ground

% % % creates G matrix with time values
G=zeros(N);


for j=1:N-1
    j
    for k=1:N
        
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k  
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            G(j,k)=t_max; %time if the path is clear, 0 if not
        
        end
    end
end

toc
save('G.mat','G','max_ptp','Px');
tts('map ready')
