close all
 load('ptps.mat')
hold on
 ptp_vec2(1:40)=ptp_vec2(1:40)*0.5;

% plot(t1,ptp_vec1,'linewidth',2)
plot(t,ptp_vec,'g','linewidth',2) % human
plot(t2,ptp_vec2,'b','linewidth',2) % short path
% plot(t4,ptp_vec4,'linewidth',2) % syracuse

% plot(t4,ptp_vec4,'linewidth',2)

grid on;xlabel('Time [sec]');ylabel('PTP [m]');

legend('Planned','Actual','fontsize',20)
