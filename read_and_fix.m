global u time_step AdaptationLayer
 
    fclose(u);
    flushinput(u);
    fopen(u);
    
    if AdaptationLayer
    fwrite(u,2,'double');%%%%%%%%%%
    end
    
    temp1=fread(u,6,'double');
    pause(time_step);
    fclose(u);
    flushinput(u);
    fopen(u);
    
    if AdaptationLayer
    fwrite(u,2,'double');%%%%%%%%%%
    end
    
    temp2=fread(u,6,'double');
    fix_inputs(temp1,temp2);
    predict_ptp;
