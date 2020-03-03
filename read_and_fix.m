global u  r  time_step
    tic
    fclose(u);
    flushinput(u);
    fopen(u);
    toc
    temp1=fread(u,6,'double');
    pause(time_step);
    fclose(u);
    flushinput(u);
    fopen(u);
    temp2=fread(u,6,'double');
    fix_inputs(temp1,temp2);
    predict_ptp;
