% % https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_Israel

clc; close all;

x=[19:1:40];
y=round(3.157407696*1.262623258.^x,0);
x=x-3;

real_y=[298 337 433 677 705 883 1071 1442 1930 2369 2693 3035 3619];
today=length(real_y);

hold on; grid on; 

plot(x(1:today+2),y(1:today+2),'.')
plot(x(1:today),real_y(1:today),'o')

for j=1:today
error(j)=abs((real_y(j)-y(j)))./max(real_y(j),y(j))*100;
text(x(j),min(y(j),real_y(j))-100,['' num2str(round(error(j),1)) '%'],'Color','red','FontSize',12)
end

xlabel('day');ylabel('num of infected');
legend('my guess','real number','Location','northwest','fontsize',40)
axis([15 15+today+3 0 max(real_y(today),y(today+2))+100])