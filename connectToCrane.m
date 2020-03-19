function udp_r=connectToCrane

udp_r = udp('', 'LocalHost', '127.0.0.1', 'LocalPort', 20103); % 20103 for vortex, 20113 for ron
udp_r.ByteOrder = 'littleEndian';
udp_r.remoteport=20102; % 20102 for vortex, 20112 for ron
udp_r.OutputBufferSize = 1024;
% udp_r.InputBufferSize = 58;%%%%
fopen(udp_r);
end