function udp_r=connectToCrane

ron=0;
RP=20102;
LP=20103;

if ron
    LP=20113;
    RP=20112;
end

    udp_r = udp('', 'LocalHost', '127.0.0.1', 'LocalPort', LP); 
    udp_r.ByteOrder = 'littleEndian';
    udp_r.remoteport=RP; 
    udp_r.OutputBufferSize = 1024;
    fopen(udp_r);

end




