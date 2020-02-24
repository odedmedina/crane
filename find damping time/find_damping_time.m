% find damping time
clear
close
clc
global distance ax to_plot obs_xy obs_dim crane_h ay vx vy vx_max vy_d_max m1 m2 M l initials axis_lim max_ptp;


xx=0;x_destination=0;results=[];

to_plot=[0 1 0]*0;

times=20;
distance_vec=1:0.5:4;
l_vec=1:50;


ptp_max=4;



max_ptp=5; crane_h=48; end_config=[49,47]; N=400;ax=0.77;
ax=0.77; ay=1.85; vx_max=1.92; vy_d_max=1.735 ;vy_u_max=1.07;m1=300 ;m2=2000; initials=[0,0];



max_theta=7.5;

hold on

time_vec=zeros(length(l));

close;


for k=1:times 
    k
    for i=1:length(l_vec) 
        i
        l=l_vec(i)+0.3*(1-2*rand);
        
        for j=1:length(distance_vec)
                  
            distance=distance_vec(j);
            initials=[(max_theta+0.5*(1-2*rand))*pi/180,0];
            
            results(i,j,k)=damp(ax,xx,x_destination);
            
        end
    end
end

results_mean=mean(results,3);
[X,Y] = meshgrid(distance_vec,l_vec);
S=surf(X,Y,results_mean);

xlabel('distance');ylabel('L');zlabel('damping time')


save('damp_time_surf.mat','results_mean','distance_vec','l_vec');

