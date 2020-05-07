close all;clear all;clc; % % % % % % % % % % % % % crane [length = 47, height=48]
tic

global max_ptp ptp_vec u time_step x l y angle l2 distance as vs_max map map_x map_y map_z crane_h ax ay vr_max vl_d_max vl_u_max end_config

map_number=1
load(['map' num2str(map_number) '.mat'])
max_ptp=5;


N=750 ;
% % % % % % % % % % % % % % % % % % % % % % Crane Parameters
crane_h=48; l2=12; crane_l=49.5; as=0.0126; ax=0.372; ay=1.85; vs_max=0.079*0.5; vr_max=1.93; vl_d_max=1.73;vl_u_max=1.064;




[Px,N]=makepoints(N);


% plot3(Px(1,:),Px(2,:),Px(3,:),'.')
% hold on; grid on;xlabel('x');ylabel('y');zlabel('z'); axis equal
% % % draw obs 
% [obsx]=makepoints2(100000);
% plot3(obsx(1,:),obsx(2,:),obsx(3,:),'k.')


% % % creates G matrix with time values


G=zeros(N);
G_eff=zeros(N);

for j=1:N-1
    j
    for k=1:N
        
        isok=linecheck(Px(:,j)',Px(:,k)');
        if  isok && j~=k  
            [t_max, t_r, t_l, t_s]=timecalc(Px(:,j)',Px(:,k)');
            G(j,k)=t_max; %time if the path is clear, 0 if not
            G_eff(j,k)=t_max+norm([Px(:,j)'-Px(:,k)']);
        
        end
    end
end

toc
save(['G' num2str(map_number) '.mat'],'G','max_ptp','Px','G_eff');
tts('map ready')
