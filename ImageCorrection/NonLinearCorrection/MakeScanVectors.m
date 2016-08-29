function [ RiseVec, FallVec, TimeVec ] = MakeScanVectors( Risetime, RiseVoltage, Falltime, Fallvoltage, NumPixels )
%MAKESCANVECTORS Summary of this function goes here
%   Detailed explanation goes here


%Row time from data:
RowTime = 0.5*( (Risetime(end)-Risetime(1)) + (Falltime(end)-Falltime(1)) ); 

% OR Row Time from user input
% FrameTime = 1/FrameRate; %[seconds]
% RowTime = FrameTime/NumPixels; %[seconds]

DeltaTimePixel = RowTime/NumPixels; % Time for each pixel - uncorrected
TimeVec = ((-NumPixels/2):(NumPixels/2)-1).*DeltaTimePixel;

Risetime = Risetime-Risetime(round(end/2)); %normalize rise time
Falltime = Falltime-Falltime(round(end/2)); %normalize rise time
Fallvoltage = flipud(Fallvoltage); % flip fall vec

% Resample (interpolate) with NumPixels
RiseVec = interp1(Risetime,RiseVoltage,TimeVec,'pchip'); %full range rise vector
FallVec = interp1(Falltime,Fallvoltage,TimeVec,'pchip'); %full range fall vector


end

