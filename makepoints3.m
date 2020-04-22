function [Px N] = makepoints(N)
% makes random points
global theta map map_x map_y map_z r x l z angle crane_h end_config

Px=[];
zz=[0:1.5:crane_h-12];
rr=[3:1.5:47];
tt=[0:0.5:2*pi];

for i=1:length(zz)
    i
    for j=1:length(rr)
        for k=1:length(tt)
            
            if ~map_check(rr(j)*cos(tt(k)),rr(j)*sin(tt(k)),zz(i))
                Px=[Px,[rr(j)*cos(tt(k));rr(j)*sin(tt(k));zz(i)]];
            end
        end
    end
end

N=length(Px);
end

