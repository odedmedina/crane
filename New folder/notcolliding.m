function [ans] = notcolliding(xx,distance1)

global x l roof distance obs_xy obs_dim crane_h ax ay vx_max vy_d_max vy_u_max axis_lim max_ptp end_config;

ans=0;
if (xx+max_ptp+distance1<obs_xy(1) || xx>obs_xy(1)+obs_dim(1)+max_ptp+distance1)|| crane_h-l>obs_xy(2)+obs_dim(2)+roof
    ans=1;
end

end
