function [ R_time, R_voltage, F_time, F_voltage ] = ResonantScannerSimulation( freq )
%RESONANTSCANNERSIMULATION Summary of this function goes here
%   Detailed explanation goes here

T = 1/freq;
del_t = T*(2*pi)/5000;

R_time = 0:del_t:(2*T);
R_voltage = sin( pi.*R_time./(2*T)-pi/2);
F_time = (2*T):del_t:(4*T);
F_voltage = sin( pi.*F_time./(2*T)-pi/2);

% plot segments
% figure;
% plot(R_time,R_voltage,'.r', F_time,F_voltage,'.b');


end

