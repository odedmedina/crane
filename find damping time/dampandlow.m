function [count,xx] = dampandlow(ax_max,xx,x_destination)

global  distance frames to_plot obs_xy obs_dim crane_h ay vx vy vx_max vy_d_max m1 m2 M l1 l2 initials axis_lim max_ptp;

l=l1+l2;
g=9.81;
vx=0;vy=0; ay=1.85;
dt=0.05;
ddt=0.025;


ax=0;

count=0;
flag=[0 0];
while flag(1)*flag(2)==0
    
%     ptp=predict_ptp2();
    
    
%     P2x=l1*sin(initials(1))+l2*sin(initials(3))+xx;
   
    if vy>vy_d_max 
        ay=0;
    end
      if abs(l1+l2-crane_h)<distance
        flag(2)=1;
        %         ay=-2*vy;
        n=10;
        ay=-vy/(n*ddt);
      end
    
      l1=l1+vy*ddt+0.5*ay*ddt^2;
      l=l1+l2;
    vy=vy+ay*ddt;
    
    
    if initials(2)>0  && initials(1)>-0.01 && (xx+vx*ddt+0.5*ax_max*ddt^2-x_destination)<distance
        ax=ax_max;
    elseif initials(2)<0  && initials(1)<0.01 && (xx+vx*ddt-0.5*ax_max*ddt^2-x_destination)>-distance
        ax=-ax_max;
    else
        %         ax=-ax_max*sign(vx);
        n=10; %time steps to breake
        ax=-vx/(n*ddt);
    end
    
    if abs((l1+l2)*initials(2)-vx)<0.05
        n=10; %time steps to breake
        ax=-vx/(n*ddt);
    end
    
    
    
    
    %     if abs(xx+vx*ddt+0.5*ax*ddt^2-x_destination)>distance
    %         ax=-0.5*vx;
    %
    %     end
    
    
    if (abs(xx-x_destination)<distance && abs(initials(1))*180/pi<0.5 ) && (l1+l2)*abs(initials(2))<0.2
        vx=0;
        ax=0;
        flag(1)=1;
        
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
    
    
    
    for j=1:0*length(t)% plot loop
        
        P1=(l*[sin(x(j,1)) -cos(x(j,1))])+[xx crane_h];
       
        try
            delete(A_c);delete(P_c1);delete(P_c2);delete(L_c1);delete(L_c2);delete(ptp_l);
        catch
        end
        axis([-10 100, -5 100]); hold on; grid on
        L_c1=line([xx,P1(1)],[crane_h P1(2)]);
       
        
%         ptp=predict_ptp2();
        % %       ptp_l(1)=errorbar(x_destination,crane_h-l1-l2,max_ptp,'horizontal','magenta');
        %         ptp_l(2)=errorbar(x_destination,crane_h-l1-l2,ptp,'horizontal','black');
        
        A_c=plot(xx, crane_h,'*k');
        P_c1=plot(P1(1) ,P1(2),'or','linewidth',6);
%         P_c2=plot(P2(1), P2(2),'or','linewidth',6);
        %         hold on
        %         frames=[frames,getframe];
        pause(0.005)
        
    end
    count=count+1;
end

count=count*ddt;



while to_plot(3)
    
    [t,x] = ode45(@(t,y)f4(y,l,g,ax,0),[0:ddt:dt],initials);
    x(3:end,:)=[];
    t(3:end)=[];
    initials=[x(end,:)];
    
    for j=1:to_plot(3)*length(t)% plot loop
        
        P1=(l1*[sin(x(j,1)) -cos(x(j,1))])+[xx crane_h];
        P2=(l2*[sin(x(j,3)) -cos(x(j,3))])+P1;
        try
            delete(A_c);delete(P_c1);delete(P_c2);delete(L_c1);delete(L_c2); delete(ptp_l);
        catch
        end
        
        L_c1=line([xx,P1(1)],[crane_h P1(2)]);
        L_c2=line([P1(1) P2(1)],[P1(2) P2(2)]);
        ptp=predict_ptp2();
         A_c=plot(xx, crane_h,'*k');
        P_c1=plot(P1(1) ,P1(2),'or','linewidth',6);
        P_c2=plot(P2(1), P2(2),'or','linewidth',6);
        %         hold on
        %         frames=[frames,getframe];
        pause(0.005)
        
    end
end




try
    delete(A_c);delete(P_c1);delete(P_c2);delete(L_c1);delete(L_c2);
catch
end
end