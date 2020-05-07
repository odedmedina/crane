function [tmax, t_r, t_l, t_s] = timecalc(p1,p2) 
global ax ay vr_max vl_d_max vl_u_max as vs_max

p1_n=[ sqrt(p1(1)^2+p1(2)^2),p1(3),atan2(p1(2),p1(1))] ;  % x,y,z to r,angle,l
p2_n=[ sqrt(p2(1)^2+p2(2)^2),p2(3),atan2(p2(2),p2(1))] ;
p1=p1_n;
p2=p2_n;



arr=ax*sign(p2(1)-p1(1));
all=ay*sign(p2(2)-p1(2));
ass=as*sign(p2(3)-p1(3));

vrr_max=vr_max;
vss_max=vs_max;

if p2(2)<p1(2)
    vll_max=vl_d_max;
else
    vll_max=vl_u_max;
end

vr=0; vl=0; vs=0;

vrr_max=vrr_max*sign(p2(1)-p1(1));
vll_max=vll_max*sign(p2(2)-p1(2));
vss_max=vss_max*sign(p2(3)-p1(3));

tmax_r=(vrr_max-vr)/arr;
rmax=vr*tmax_r+0.5*arr*tmax_r^2;

tmax_l=(vll_max-vl)/all;
lmax=vl*tmax_l+0.5*all*tmax_l^2;

tmax_s=(vss_max-vs)/ass;
smax=vs*tmax_s+0.5*ass*tmax_s^2;



t_r1=(-vr-sqrt(vr^2-2*arr*(p1(1)-p2(1))))/(arr);
t_r2=(-vr+sqrt(vr^2-2*arr*(p1(1)-p2(1))))/(arr);
t_r=max(t_r1,t_r2);

t_l1=(-vl-sqrt(vl^2-2*all*(p1(2)-p2(2))))/(all);
t_l2=(-vl+sqrt(vl^2-2*all*(p1(2)-p2(2))))/(all);
t_l=max(t_l1,t_l2);

t_s1=(-vs-sqrt(vs^2-2*ass*(p1(3)-p2(3))))/(ass);
t_s2=(-vs+sqrt(vs^2-2*ass*(p1(3)-p2(3))))/(ass);
t_s=max(t_s1,t_s2);



if t_r>tmax_r
    t_r=tmax_r+(p2(1)-p1(1)-rmax)/vrr_max;
end

if t_l>tmax_l
    t_l=tmax_l+(p2(2)-p1(2)-lmax)/vll_max;
end

if t_s>tmax_s
    t_s=tmax_s+(p2(3)-p1(3)-smax)/vss_max;
end

tmax=max([t_r,t_l,t_s]);
if  isnan(tmax)
    tmax=0;
end
    

end
