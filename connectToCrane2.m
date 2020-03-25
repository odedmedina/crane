function udp_r=connectToCrane2
global AdaptationLayer

RP=20102;
LP=20103;

if AdaptationLayer
    LP=20113;
    RP=20112;
end

udp_r = udp('127.0.0.1', 'RemotePort', RP, 'LocalPort', LP); % 20103 for vortex, 20113 for ron
udp_r.ByteOrder = 'littleEndian';
udp_r.OutputBufferSize = 1024;
fopen(udp_r);
end




