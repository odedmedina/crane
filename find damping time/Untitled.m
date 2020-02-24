 
load('damp_time_single_p_plus_down_time.mat');

[X,Y] = meshgrid(distance_vec,l1_vec);
S=surf(X,Y,results_mean);

xlabel('distance');ylabel('L1');zlabel('damping time')

load('damp_time_single_p_while_down_time.mat');


hold on
S=surf(X,Y,results_mean);