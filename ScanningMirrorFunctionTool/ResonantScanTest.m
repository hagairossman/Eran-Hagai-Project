clear; clc; close all;

addpath(genpath('../')); % add all relevent folders to path
parentpath = cd(cd('..'));

%% User inputs the frequency
userInput = inputdlg({'Enter frequency [KHz]:'},'Enter frequency',1,{'100'});
userFreq = str2double(userInput{1});
[ R_time, R_voltage, F_time, F_voltage ] = ResonantScannerSimulation( userFreq*10^3 );

%% Save to GalvoMatrices
Resonantfilename = [parentpath, '\Data\ResonantMatrices\', strrep(num2str(userFreq), '.', '_'), 'KHz.mat'];
save(Resonantfilename, 'R_time', 'R_voltage', 'F_time', 'F_voltage')
%% Plot segments (optional)
figure;
plot(R_time,R_voltage,'.r', F_time,F_voltage,'.b');