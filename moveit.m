function [] = moveit(x_destination,y_destination,l_destination)

global  map map_x map_y map_z ptp_vec u ptp x y z r l angle omega alpha theta p crane_h crane_h angle_destination phi vr_max vl_d_max vl_u_max omega_max roof


try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end

counter2=0;

read_and_fix
r_destination=sqrt(x_destination^2+y_destination^2);
angle_destination=atan2(y_destination,x_destination);
fix_angles;
    
    if r_destination>47
        r_destination=47;
    end
    if r_destination<3
        r_destination=3;
    end
    if l_destination<10
        l_destination=10;
    end
    
    limit=0.5;
    ar=0; al=0; as=0; vs=0.5; vl=1; vr=1;
    
    direction=[sign(r_destination-r) sign(angle_destination-angle) sign(l_destination-l)];
    dr=abs(r_destination-r);
    dangle=abs(angle_destination-angle);
    dl=abs(l_destination-l);
    
    angle_destination
    
    angle_destination=angle_destination-direction(2)*omega_max*(1+omega_max/(2*alpha))
    
    [t_max, t_r, t_l, t_s]=timecalc([x,y,l_destination],[x_destination,y_destination,l]) ;
    
%     if t_max == t_l
%         vr=vr*t_r/t_l;
%         vs=vs*t_s/t_l;
%     elseif t_max == t_r
%         vl=vl*t_l/t_r;
%         vs=vs*t_s/t_r;
%     elseif t_max == t_s
%         vr=vr*t_r/t_s;
%         vl=vl*t_l/t_s;
%     end
%     
    
    
    
    
    flag=[0 0 0];
    
    if abs(r-r_destination)<limit %flag if reached destination
        flag(1)=1;
    end
    if abs(angle-angle_destination)<0.01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        flag(2)=1;
    end
    if abs(l-l_destination)<limit
        flag(3)=1;
    end
    
    
    
    
    
    while flag(1)*flag(2)*flag(3)==0
        
        
        read_and_fix; fix_angles

        
        direction=[sign(r_destination-r) sign(angle_destination-angle) sign(l_destination-l)];
        
        
        ar=direction(1)*vr;
        as=direction(2)*vs;
        al=direction(3)*vl;
        
        if abs(r-r_destination)<limit %stop if reached destination
            flag(1)=1;
            ar=0;
        end              
            
        if abs(angle-angle_destination)<0.01 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
            flag(2)=1;
            as=0;
        else
            flag(2)=0;
        end
     
        
        if abs(l-l_destination)<limit
            flag(3)=1;
            al=0;
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% in move damping
%         if sign(theta)~=sign(direction(1)) && abs(theta*180/pi)>1
%             ar=0.2*direction(1);
%         end
%         
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     anti collision
        if map_check((r+2*ptp+1)*cos(angle),(r+2*ptp+1)*sin(angle),crane_h-l) && direction(1)==1
            'front warning (m)'
            counter2=counter2+1
            fwrite(u,[0,-al,as,1],'double');%pause(0.1)
            ar=0;
        end
        if map_check((r-2*ptp-1)*cos(angle),(r+2*ptp+1)*sin(angle),crane_h-l) && direction(1)==-1
            'back warning (m)'
            counter2=counter2+1
            fwrite(u,[0,-al,as,1],'double');%pause(0.1)
            ar=0;
        end
        %        while map_check(r,y+2,crane_h-l) && direction(3)==1
        %         'left warning (m)'
        %         counter2=counter2+1
        %         fwrite(u,[ar,-al,0,1],'double');%pause(0.1)
        %         read_and_fix
        %     end
        %     while map_check(r,y-2,crane_h-l) && direction(3)==-1
        %         'right warning (m)'
        %         counter2=counter2+1
        %         fwrite(u,[ar,-al,0,1],'double');%pause(0.1)
        %         read_and_fix
        %     end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        fwrite(u,[ar,-al,as,1],'double');
        
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
    
    
end
