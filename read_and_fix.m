global u time_step
 
    fclose(u);
    flushinput(u);
    fopen(u);
    
    temp1=fread(u,6,'double');
    pause(time_step);
    fclose(u);
    flushinput(u);
    fopen(u);
    temp2=fread(u,6,'double');
    fix_inputs(temp1,temp2);
    predict_ptp;
