function [] = moveit(x_destination,y_destination,l_destination)

global   max_ptp ptp_counter slow_flag slow_factor map map_x map_y map_z ptp_vec u ptp x y z r l angle omega alpha theta p crane_h angle_destination phi vr_max vl_d_max vl_u_max omega_max roof


l_destination=crane_h-l_destination;
% view([0 90]);

try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end
read_and_fix


front_counter=0;back_counter=0;right_counter=0;left_counter=0;


r_destination=sqrt(x_destination^2+y_destination^2);
angle_destination=atan2(y_destination,x_destination);
fix_angles;

r_direction=sign(r_destination-r);
l_direction=sign(l_destination-l);
s_direction=sign(angle_destination-angle);




if r_destination>50
    r_destination=50;
end
if r_destination<3
    r_destination=3;
end
if l_destination<10
    l_destination=10;
end

limit=0.5;
vs=0.5; vl=1; vr=1;
if slow_flag
    vs=0.5/slow_factor; vl=1/slow_factor; vr=1/slow_factor;
end

fix_angles;
dr=abs(r_destination-r);
dangle=abs(angle_destination-angle);
dl=abs(l_destination-l);



% if abs(angle-angle_destination)*180/pi>5
%     angle_destination=angle_destination-s_direction*omega_max*(1+omega_max/(2*alpha))-0.055*s_direction;
%     % angle_destination=angle_destination-s_direction*omega_max*(1+omega_max/(2*alpha));
% end


[t_max, t_r, t_l, t_s]=timecalc([x,y,l_destination],[x_destination,y_destination,l]) ;

% if t_max == t_l
%     vr=vr*t_r/t_l;
%     vs=vs*t_s/t_l;
% elseif t_max == t_r
%     vl=vl*t_l/t_r;
%     vs=vs*t_s/t_r;
% elseif t_max == t_s
%     vr=vr*t_r/t_s;
%     vl=vl*t_l/t_s;
% end

flag=[0 0 0];

if abs(r-r_destination)<limit %flag if reached destination
    flag(1)=1;
end
if abs(angle-angle_destination)<0.01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    flag(2)=1;
end
if abs(l-l_destination)<limit
    flag(3)=1;
end




while flag(1)*flag(2)*flag(3)==0
    
    read_and_fix; fix_angles
    
    ar=sign(r_destination-r)*vr;
    al=sign(l_destination-l)*vl;
    as=sign(angle_destination-angle)*vs;
    
    if abs(angle_destination-angle)*180/pi<8 && slow_flag==0
        as=0.25*as;
    end
   
    if abs(r-r_destination)<limit %stop if reached destination
        flag(1)=1;
        ar=0;
    end
    
    if abs(angle-angle_destination)<0.01 %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%% %%%%%%%%%%%%%%
        flag(2)=1;
        as=0;
        
    end
    
    
    if abs(l-l_destination)<limit
        flag(3)=1;
        al=0;
    end
    
    %
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% in move damping
    if 0
        if sign(theta)~=sign(r_direction) && abs(theta*180/pi)>1 && ar
            ar=0.2*r_direction;
        end
    end 
    
    if 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% anti collision
        angle_vec=0:0.017:2*pi;
        temp=max_ptp;
        max_ptp=0;
        ptp_factor=1;
        
        for j=1:length(angle_vec)
            if  map_check(x+ptp_factor*ptp*cos(angle_vec(j)+angle),y+ptp_factor*ptp*sin(angle_vec(j)+angle),z)
                if (angle_vec(j)*180/pi <45 || angle_vec(j)*180/pi > 315) && r_direction==1
                    ar=-1;
                end
                if (angle_vec(j)*180/pi <225 && angle_vec(j)*180/pi>135) && r_direction==-1
                    ar=1;
                end
                if (angle_vec(j)*180/pi <135 && (angle_vec(j))*180/pi>45) && s_direction==1
                    as=-0.5;
                end
                if (angle_vec(j)*180/pi <315 && angle_vec(j)*180/pi > 225) && s_direction==-1
                    as=0.5;
                end
                if (angle_vec(j)+angle)*180/pi>360
                    (angle_vec(j)+angle)*180/pi-360
                else
                    (angle_vec(j)+angle)*180/pi
                end
                plot3(x+ptp_factor*ptp*cos(angle_vec(j)+angle),y+ptp_factor*ptp*sin(angle_vec(j)+angle),z,'*r','markersize',10)
            end
            
        end
        if  map_check(x,y,z) && al>0
            al=0;
        end
        max_ptp=temp;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
            fwrite(u,[ar,-al,as,1],'double');
%     fwrite(u,[0,-0,0,1],'double');
    
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
        view([mod(toc,90) mod(toc,90)]);
    
    
end

fwrite(u,[0,0,0,1],'double');


end
