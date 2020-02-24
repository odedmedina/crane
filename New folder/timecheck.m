clear; close all; clc;

global time_step x l angle theta phi vx theta_dot 

time_step=0.1;

i=1;

try
    u=connectToCrane;
catch
    comfix
    u=connectToCrane;
end

    flushinput(u);temp1=fread(u,6,'double');
    pause(time_step);
    flushinput(u);temp2=fread(u,6,'double');
    
    fix_inputs(temp1,temp2)
    clearvars temp1 temp2
   

    
    temp=x;
    
    tic
fwrite(u,[0,0,0],'double')
fwrite(u,[1,0,0],'double')
while abs(x-temp(1) <0.1)
    
    flushinput(u);
    temp1=fread(u,6,'double');
    pause(time_step);
    flushinput(u);
    temp2=fread(u,6,'double');
    
    fix_inputs(temp1,temp2)
    clearvars temp1 temp2
   fwrite(u,[1,0,0],'double')
    

  temp(1);
end
    
   toc 
    



