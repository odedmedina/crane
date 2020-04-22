% find_damp_move_times
global  use_damp_move last_time end_config vortex_damp_flag

use_damp_move=1;

times_vec=[];
times=[];
read_and_fix
        
vortex_damp_flag=1;
end_config=[20,0,34];
% damp_move_test(x+10)


use_damp_move=0;
vortex_damp_flag=1;
for j=34:38
    use_damp_move=0;
    j
    read_and_fix
    moveit(20,0,j)
        moveit(20,0,j)
        vortex_damp
        use_damp_move=1;

for i=1:5
    
    if x<35
        end_config=[x+10,0,z];
        damp_move_test(x+10)
    else
        end_config=[x-10,0,z];
        damp_move_test(x-10);
    end
        times(i)=last_time;
end
times_vec(j)=mean(times)
end
        times_vec2=times_vec;
save('times_with_damp1.mat','times_vec2');
        
    