
global l2 crane_l in_move_damping last_move p slow_flag slow_factor max_ptp ptp_vec u time_step r x l y z angle distance alpha ptp_counter
global map map_x map_y map_z crane_h ax theta ay vr_max vl_d_max vl_u_max omega_max end_config AdaptationLayer r_final_destination use_damp_move

moveit(10,0,20)
read_and_fix
    end_config=[x,y,z];
    vortex_damp
    

read_and_fix

theta_vec=[];
x_0=x;
tic
if x_0<25
    crane_write(0.25,0,0,1);
    
    while x<x_0+20
        read_and_fix
        theta_vec=[theta_vec abs(theta)];
%         theta*180/pi
    end
    
else
    crane_write(-0.25,0,0,1);
    while x>x_0-20
        read_and_fix
        theta_vec=[theta_vec abs(theta)];
%         theta*180/pi
    end
end
%     vr=20/toc;
%     max_theta=max(theta_vec)*180/pi
%     max_theta_t=acos(1-(vr^2)/(2*9.81*l))*180/pi
%     error=(max_theta_t-max_theta)/max_theta_t*100
    
    
    while theta<0
        read_and_fix
         theta_vec=[theta_vec abs(theta)];
    end
   
    crane_write(0,0,0,1);
    
    
    while theta>0
        read_and_fix
         theta_vec=[theta_vec abs(theta)];
    end
   read_and_fix
   
   
   
    end_config=[x,y,z];
    vortex_damp
    plot(theta_vec*180/pi)

