function [ R_time, R_voltage, F_time, F_voltage, userFreq  ] = MakeResonantScanner( )
%MAKERESONANTSCANNER Summary of this function goes here
%   Detailed explanation goes here
% User inputs the frequency
userInput = inputdlg({'Enter frequency [KHz]:'},'Enter frequency',1,{'100'});
userFreq = str2double(userInput{1});
[ R_time, R_voltage, F_time, F_voltage ] = ResonantScannerSimulation( userFreq*10^3 );


end

