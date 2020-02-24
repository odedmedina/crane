function [count,xx] = damp(ax_max,xx,x_destination)

global  distance  theta theta_dot ptp frames to_plot obs_xy obs_dim crane_h ay vx vy vx_max vy_max m1 m2 M l initials axis_lim max_ptp;

counter=0;
g=9.81;
vx=0;
dt=0.05;
ddt=0.025;


ax=0;

count=0;
flag=1;
while flag
    
    theta=initials(1); theta_dot=initials(2);
     predict_ptp2;
    
    
    
    
    if initials(2)>0  && initials(1)*180/pi>0.5 && (xx+vx*ddt+0.5*ax_max*ddt^2-x_destination)<distance
        ax=min(ax_max,ax_max*1.5*l/crane_h);
    elseif initials(2)<0  && initials(1)*180<0.5 && (xx+vx*ddt-0.5*ax_max*ddt^2-x_destination)>-distance
          ax=max(-ax_max,-ax_max*1.5*l/crane_h);
    else
      ax=0;
%         n=10; %time steps to breake
%         ax=-vx/(n*ddt);
    end
    
    if abs((l)*initials(2)-vx)<0.05
%         n=10; %time steps to breake
%         ax=-vx/(n*ddt);
ax=0;
    end
    
    
%     if (abs(xx-x_destination)<distance && abs(initials(1))*180/pi<0.5 ) && (l)*abs(initials(2))<0.5
    if ptp<0.5
        counter=counter+1;
%         vx=0;
%         ax=0;
        if counter==5
            break
        end
        
    end
    
    xx=xx+vx*ddt+0.5*ax*ddt^2;
    vx=vx+ax*ddt;
    
    if abs(vx)>vx_max
        vx=vx_max*sign(vx);
        ax=0;
    end
    
    [t,x] = ode45(@(t,y)f4(y,l,g,ax,0),[0:ddt:dt],initials);
    x(3:end,:)=[]; t(3:end)=[];
    initials=[x(end,:)];
    
  
    count=count+1;
end

count=count*ddt;

end