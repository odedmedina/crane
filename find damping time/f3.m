function dy = f3(y,m1,m2,l1,l2,g,xdd,ydd)

xxx=xdd*cos(y(1))/(l1+l2); %acceleration from trolley
yyy=ydd*sin(y(1))*cos(y(1))/l1; %acceleration from cable
damp=0.0;   % damping


dy(1,1) = y(2);
dy(2,1) = (-g*(2*m1+m2)*sin(y(1))-m2*g*sin(y(1)-2*y(3))-2*sin(y(1)-y(3))*m2*(y(4)^2*l2+y(2)^2*l1*cos(y(1)-y(3))))/...
          (l1*(2*m1+m2-m2*cos(2*y(1)-2*y(3))))-xxx-yyy-damp*y(2);

dy(3,1) = y(4);
dy(4,1) = (2*sin(y(1)-y(3))*(y(2)^2*l1*(m1+m2)+g*(m1+m2)*cos(y(1))+y(4)^2*l2*m2*cos(y(1)-y(3))))/...
    (l2*(2*m1+m2-m2*cos(2*y(1)-2*y(3))));

% -g/(l+ldot*t)*sin(x(1))-2*ldot/(l+ldot*t)*x(2)