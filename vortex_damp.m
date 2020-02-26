global map map_x map_y map_z ptp_vec ptp r x y l vr theta theta_dot distance p crane_h end_config phi obs_xy obs_dim obs_num  roof

x_destination=x;

counter=0;damp_counter=0;
fwrite(u,[0,0,0,1],'double')
while 1
    read_and_fix
    
    if (theta_dot>0 && theta*180/pi>0.5 && x<x_destination+distance) %|| x<x_destination-distance
        ar=min(1,1.5*l/crane_h);
        
    elseif (theta_dot<0 && theta*180/pi<-0.5 && x>x_destination-distance) %|| x>x_destination+distance
        ar=max(-1,-1.5*l/crane_h);
        
    else
        ar=0;
    end
    
    if abs(l*theta_dot-vr)<0.05 && abs(x-x_destination)<distance
        ar=0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     anti collision
        if map_check((r+2*ptp+1)*cos(angle),(r+2*ptp+1)*sin(angle),crane_h-l) && ar>0
        
        damp_counter=damp_counter+1
        fwrite(u,[0,0,0,1],'double');%pause(0.1)
        ar=0;
    end
    if map_check((r-2*ptp-1)*cos(angle),(r+2*ptp+1)*sin(angle),crane_h-l) && ar<0
        
        damp_counter=damp_counter+1
        fwrite(u,[0,0,0,1],'double');%pause(0.1)
        ar=0;
    end
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    fwrite(u,[ar,0,0,1],'double');
    pause(0.1)
    
    if ptp<0.5
        counter=counter+1;
        ar=0;
        if counter==5
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



