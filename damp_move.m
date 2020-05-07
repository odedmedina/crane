function damp_move(al,as,r_direction,time_for_ptp,limit,l_destination);

% damp_move
global  l2 ptp_s ptp_temp end_config in_move_damping last_move max_ptp ptp_counter slow_flag slow_factor map map_x map_y map_z ptp_vec u ptp x y z r l angle omega alpha theta theta_dot p crane_h angle_destination phi vr_max vl_d_max vl_u_max omega_max roof r_final_destination theta_max

vs=0.5; vl=1; vr_temp=1;
if slow_flag
    vs=0.5/slow_factor*1.5; vl=1/slow_factor; vr_temp=1/slow_factor;
end

fprintf('Damp Move Was Made \n\n')
% disp(time_for_ptp)
crane_write(0,-al,as,1)

while sign(theta)~=sign(r_direction) && sign(theta_dot)~=sign(r_direction) && abs(theta)*180/pi>1
 
    read_and_fix; fix_angles
    plot_load
   
    al=sign(l_destination-l)*vl;
    as=sign(angle_destination-angle)*vs;   
    if abs(angle_destination-angle)*180/pi<7 && slow_flag==0 && last_move
        as=0.25*as;
    end
    if abs(angle-angle_destination)<0.015 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
        flag(2)=1;
        as=0; 
    end  
    if abs(l-l_destination)<limit
        flag(3)=1;
        al=0;
    end
    crane_write(0,-al,as,1)
    
    
end
ml=2000;mp=162;
l=(ml*l+mp*l2)/(ml+mp);


%     pause(0.25*2*pi*sqrt(l/9.81)-time_for_ptp*0.5)
temp=toc;
while toc-temp<(0.25*2*pi*sqrt(l/9.81)-time_for_ptp*0.5)
    read_and_fix; fix_angles
    plot_load
   
    al=sign(l_destination-l)*vl;
    as=sign(angle_destination-angle)*vs;   
    if abs(angle_destination-angle)*180/pi<7 && slow_flag==0 && last_move
        as=0.25*as;
    end
    if abs(angle-angle_destination)<0.015 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
        flag(2)=1;
        as=0; 
    end  
    if abs(l-l_destination)<limit
        flag(3)=1;
        al=0;
    end
    crane_write(0,-al,as,1)
end
    


crane_write(1*r_direction,-al,as,1)
read_and_fix

theta_max_temp=theta_max*180/pi;

% if theta*r_direction*180/pi>abs(theta_max_temp)*0.33 && (r_final_destination-r)*r_direction > 0%- limit
%    disp(['1 ' num2str(theta*r_direction*180/pi)])
%     read_and_fix
%     plot_load
% end

read_and_fix       
while  theta*r_direction*180/pi>0 && abs(r-(r_final_destination+2*r_direction))>0.5   %- limit
  if theta*r_direction*180/pi>abs(theta_max_temp)*0.33

    read_and_fix; fix_angles
    plot_load
   
    al=sign(l_destination-l)*vl;
    as=sign(angle_destination-angle)*vs;   
    if abs(angle_destination-angle)*180/pi<7 && slow_flag==0 && last_move
        as=0.25*as;
    end
    if abs(angle-angle_destination)<0.015 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
        flag(2)=1;
        as=0; 
    end  
    if abs(l-l_destination)<limit
        flag(3)=1;
        al=0;
    end
        
    crane_write(1*r_direction,-al,as,1)
  else
     read_and_fix; fix_angles
    plot_load
   
    al=sign(l_destination-l)*vl;
    as=sign(angle_destination-angle)*vs;   
    if abs(angle_destination-angle)*180/pi<7 && slow_flag==0 && last_move
        as=0.25*as;
    end
    if abs(angle-angle_destination)<0.015 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
        flag(2)=1;
        as=0; 
    end  
    if abs(l-l_destination)<limit
        flag(3)=1;
        al=0;
    end
 
    crane_write(l/crane_h*r_direction,-al,as,1)
   
  end
end


r_final_destination=9999; %make it go once