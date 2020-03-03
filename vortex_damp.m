global phi_dot phi angle ptp_s map map_x map_y map_z ptp_vec ptp r x y l z vr theta theta_dot distance p crane_h end_config phi obs_xy obs_dim obs_num  roof

r_destination=r;
fix_angles
angle_destination=angle;

counter=0;damp_counter=0;
fwrite(u,[0,0,0,1],'double')
while 1
    read_and_fix
    
    if (theta_dot>0 && theta*180/pi>0.5 && r<r_destination+distance) %|| r<r_destination-distance
        ar=min(1,1.5*l/crane_h);
        
    elseif (theta_dot<0 && theta*180/pi<-0.5 && r>r_destination-distance) %|| r>r_destination+distance
        ar=max(-1,-1.5*l/crane_h);
        
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
    
    
    
    fwrite(u,[ar,0,as,1],'double');
    pause(0.1)
    
    if ptp<0.5 && ptp_s<0.5
        counter=counter+1;
        ar=0;as=0;
        if counter==7
            break
        end
    else
        counter=0;
        
    end
    
    try
        delete(p)
    catch
    end
    
    pp(1)=plot3(x+l*sin(theta),y,crane_h-l*cos(theta),'ob','markersize',3);% actual mass
    p(2)=plot3(x,y,crane_h-l,'*y','markersize',15); % mass center
    p(3)= plot3(x, y ,crane_h,'sw','MarkerSize',12); % trolly
    p(4)=plot3([x x+l*sin(theta)],[y y],[crane_h crane_h-l*cos(theta)],'color','black'); %line (cable)
    p(5)=plot3([-12*cos(angle) 50*cos(angle)],[-12*sin(angle) 50*sin(angle)],[crane_h crane_h],'linewidth',5,'color',[0.8500, 0.3250, 0.0980]); %jib
    p(6)=plot3([-12*cos(angle) 0 50*cos(angle)],[-12*sin(angle) 0 50*sin(angle)],[crane_h crane_h+5 crane_h],'linewidth',2,'color','black'); % cable
    p(7)=plot3([-11*cos(angle) -5*cos(angle)],[-11*sin(angle) -5*sin(angle)],[crane_h-1 crane_h-1],'linewidth',8,'color','black'); % weight
    ptp_vec=[ptp_vec ptp];
    
end
fwrite(u,[0,0,0,1],'double');
% tts('Damped');



