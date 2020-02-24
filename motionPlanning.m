clear
close
clc
x=0:0.1:10;
depth=-10:0.1:10;

z=0.1*(1+sin(depth));
y=0.2*sin(0.9*x)+0.7*sin(0.05*x); % +z;

cs=y(1);%+0.1*rand;
cg=y(end);%+0.1*rand;

plot(x,y)

a=0.000001*(1-2*rand(1,5));
a(1)=0;
for i=1:length(x)
for j=1:length(a) 
    X(j,i)=x(i)^(j-1);
end
end

for i=1:length(x)

    yy(i)=a*X(:,i);

end



hold on
plot(x,yy);

while abs(yy(end)-cg)>0.001
    abs(yy(end)-cg)
%    f0=yy(end)-cg;
   
   g=a*0; 
   temp=a*0;
   
   for j=2:length(a) 
       temp=a*0;
       temp(j)=0.00000001;
   g(j)=(a+temp)*X(:,end)-cg;
   end 
   a=a-0.0000001*g;
    yy(end)=a*X(:,end);
    
end


for i=1:length(x)

    yy(i)=a*X(:,i);

end

hold on
plot(x,yy,'k');





