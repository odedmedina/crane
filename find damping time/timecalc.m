function [tmax, t_x, t_l] = timecalc(p1,p2)
global ax ay vx_max vy_d_max vy_u_max

ar=ax*sign(p2(1)-p1(1));
al=ay*sign(p2(2)-p1(2));
vr_max=vx_max;
vr=0; vl=0;

if p2(2)<p1(2)
    vl_max=vy_d_max;
else
    vl_max=vy_u_max;
end

vr_max=vr_max*sign(p2(1)-p1(1));
vl_max=vl_max*sign(p2(2)-p1(2));

tmax_r=(vr_max-vr)/ar;
rmax=vr*tmax_r+0.5*ar*tmax_r^2;
tmax_l=(vl_max-vl)/al;
lmax=vl*tmax_l+0.5*al*tmax_l^2;


t_r1=(-vr-sqrt(vr^2-2*ar*(p1(1)-p2(1))))/(ar);
t_r2=(-vr+sqrt(vr^2-2*ar*(p1(1)-p2(1))))/(ar);
t_x=max(t_r1,t_r2);


t_l1=(-vl-sqrt(vl^2-2*al*(p1(2)-p2(2))))/(al);
t_l2=(-vl+sqrt(vl^2-2*al*(p1(2)-p2(2))))/(al);
t_l=max(t_l1,t_l2);



if t_x>tmax_r
    t_x=tmax_r+(p2(1)-p1(1)-rmax)/vr_max;
end

if t_l>tmax_l
    t_l=tmax_l+(p2(2)-p1(2)-lmax)/vl_max;
end

tmax=max(t_x,t_l);


end
