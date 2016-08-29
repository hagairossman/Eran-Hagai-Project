function [ L_Vec ] = MakeLinearPositionVector( TimeVec, RiseVec, mid_amp, NumPixels )
%MAKELINEARPOSITIONVECTOR Summary of this function goes here
%   Detailed explanation goes here

% Polyfit a linear vector 
low = round(NumPixels/2)-mid_amp;
high = round(NumPixels/2)+mid_amp;
x_samples = TimeVec(low:high);
y_samples = RiseVec(low:high);
p = polyfit(x_samples, y_samples,1);
CenterSlope = p(1);

% Older method:
% Evaluate two-sided derivitive at center
% x1 = TimeVec(round(NumPixels/2)-mid_amp); y1 = RiseVec(round(NumPixels/2)-mid_amp); 
% x2 = TimeVec(round(NumPixels/2)+mid_amp); y2 = RiseVec(round(NumPixels/2)+mid_amp); 
% CenterSlope = (y2-y1)/(x2-x1);


% build linear position vector
L_Vec = RiseVec(NumPixels/2)+TimeVec.*CenterSlope;

end

