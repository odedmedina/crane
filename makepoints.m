function [Px N] = makepoints(N)
% makes random points
global theta map map_x map_y map_z r x l z angle crane_h end_config 

Px=[];

while length(Px)<N
  
    zz=(crane_h-10)*rand;  
    rr=47*rand+3;
    tt=rand*2*pi;
    
    

    %      check
    if ~map_check(rr*cos(tt),rr*sin(tt),zz)
        Px=[Px,[rr*cos(tt);rr*sin(tt);zz]];
    end
    
end

% for i=1:40
%     if ~map_check(end_config(1),end_config(2),i)
%         Px=[Px,[end_config(1);end_config(2);i]];
%     end
% end




% Px=[Px,[end_config(1);end_config(2);end_config(3)]]; % X & Y
N=length(Px);
end

