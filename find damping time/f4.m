function dy = f4(y,l,g,xdd,ydd)

xxx=xdd*cos(y(1))/(l); %acceleration from trolley
yyy=ydd*sin(y(1))*cos(y(1))/l; %acceleration from cable
damp=0.0;   % damping


dy(1,1) = y(2);
dy(2,1) = (-g/l*sin(y(1)))-xxx-yyy-damp*y(2);


% -g/(l+ldot*t)*sin(x(1))-2*ldot/(l+ldot*t)*x(2)