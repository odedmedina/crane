global angle angle_destination

if angle_destination<0
    angle_destination=angle_destination+2*pi;
end
while angle_destination>2*pi
    angle_destination=angle_destination-2*pi;
end
while abs(angle_destination-angle)>pi
    if angle_destination>angle
        angle_destination=angle_destination-2*pi;
    else
        angle_destination=angle_destination+2*pi;
    end
end