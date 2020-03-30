global phi_dot phi angle ptp_s map map_x map_y map_z ptp_vec ptp r x y l z vr theta theta_dot distance p crane_h end_config phi obs_xy obs_dim obs_num  roof

read_and_fix
% r_destination=r;
% angle_destination=angle;


r_destination=sqrt(end_config(1)^2+end_config(2)^2);
angle_destination=atan2(end_config(2),end_config(1));

counter=0;damp_counter=0;
crane_write(0,0,0,1)
while 1
    read_and_fix
    
    if (theta_dot>0 && theta*180/pi>0.5 && r<r_destination+distance) %|| r<r_destination-distance
        ar=min(1,1*l/crane_h);
        
    elseif (theta_dot<0 && theta*180/pi<-0.5 && r>r_destination-distance) %|| r>r_destination+distance
        ar=max(-1,-1*l/crane_h);
        
    else
        ar=0;
    end
    
    if abs(l*theta_dot-vr)<0.05 && abs(r-r_destination)<distance
        ar=0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (phi_dot>0 && phi*180/pi>0.5 && angle*180/pi<angle_destination*180/pi+5) %|| x<x_destination-distance
        as=0.3;
        
    elseif (phi_dot<0 && phi*180/pi<-0.5 && angle*180/pi>angle_destination*180/pi-5) %|| x>x_destination+distance
        as=-0.3;
        
    else
        as=0;
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% anti collision
if 0
    angle_vec=0:0.017:2*pi;
    temp=max_ptp;
    max_ptp=0;
    ptp_factor=1;
    
    for j=1:length(angle_vec)
        if  map_check(x+ptp_factor*ptp*cos(angle_vec(j)+angle),y+ptp_factor*ptp*sin(angle_vec(j)+angle),z)
            if (angle_vec(j)*180/pi <45 || angle_vec(j)*180/pi > 315) && ar>0
                ar=-1;
            end
            if (angle_vec(j)*180/pi <225 && angle_vec(j)*180/pi>135) && ar<0
                ar=1;
            end
            if (angle_vec(j)+angle)*180/pi>350
                (angle_vec(j)+angle)*180/pi-360
            else
                (angle_vec(j)+angle)*180/pi
            end
            plot3(x+ptp_factor*ptp*cos(angle_vec(j)+angle),y+ptp_factor*ptp*sin(angle_vec(j)+angle),z,'*r','markersize',10)
        end
        
    end
    max_ptp=temp;
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    crane_write(ar,0,as,1);
    pause(0.1)
    
    if ptp<0.5 && ptp_s<0.5
        counter=counter+1;
        ar=0;as=0;
        if counter==2
            break
        end
    else
        counter=0;
        
    end
    plot_load
    
end
crane_write(0,0,0,1);
% tts('Damped');



