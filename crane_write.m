function [] = crane_write(trolley,cable,slew,command)

global u AdaptationLayer


if AdaptationLayer
fwrite(u,[1,trolley,cable,slew,command],'double');
else
    fwrite(u,[trolley,cable,slew,command],'double');
end
