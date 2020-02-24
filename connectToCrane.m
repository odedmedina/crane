function udp_r=connectToCrane

udp_r = udp('', 'LocalHost', '127.0.0.1', 'LocalPort', 20103);
udp_r.ByteOrder = 'littleEndian';
udp_r.remoteport=20102;
udp_r.OutputBufferSize = 1024;
% udp_r.InputBufferSize = 58;%%%%
fopen(udp_r);
end