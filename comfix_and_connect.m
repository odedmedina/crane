function comfix_and_connect
global u

try
    u=connectToCrane;
catch
    s=instrfind;fclose(s);clear s
    u=connectToCrane;
end
end


% udp_r.OutputBufferSize = 1024;
