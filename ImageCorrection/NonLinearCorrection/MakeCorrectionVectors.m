function [ CorrVecRiseRaw, CorrVecFallRaw, CorrVecRise, CorrVecFall, CorrVecBoth, CorrVecSymRise, CorrVecSymFall, LinVecRise, LinVecFall ] = MakeCorrectionVectors( RiseVec, FallVec, TimeVec, NumPixels, fix_params )
%MAKECORRECTIONVECTORS Summary of this function goes here
%   Detailed explanation goes here

%% load fix parameters
% Reminder: fix_params = [mid_amp, thresh, smooth_span, stretch, gaussfiltsigma];
mid_amp = fix_params(1);
thresh = fix_params(2);
smooth_span = fix_params(3);

% ScanVec = [F_voltage', R_voltage'];
% ScanTimeVec = [F_time', R_time'];
% figure; plot(ScanTimeVec, ScanVec,'.')

%% Make Linear  and Correction vectors
%Make linear vectors:
[ LinVecRise ] = MakeLinearPositionVector( TimeVec, RiseVec, mid_amp, NumPixels );
[ LinVecFall ] = MakeLinearPositionVector( TimeVec, FallVec, mid_amp, NumPixels );

% make fix of negative values:
% RiseVec = RiseVec + min(min(([RiseVec, LinVecRise])));
% LinVecRise = LinVecRise + min(min(([RiseVec, LinVecRise])));
% FallVec = FallVec + min([FallVec, LinVecFall]);
% LinVecFall = LinVecFall + min([FallVec, LinVecFall]);

% Make Correction Vectors:
CorrVecRise = LinVecRise./RiseVec;
CorrVecFall = LinVecFall./FallVec;
% retain "raw" nonfixed CorrVecs:
CorrVecRiseRaw = CorrVecRise;
CorrVecFallRaw = CorrVecFall;

%% Correction Vector fixes
% Manual fixes
CorrVecRise(isnan(CorrVecRise)) = 1;
center_part = find(CorrVecRise <= thresh);
CorrVecRise(min(center_part):max(center_part)) = 1;
CorrVecFall(isnan(CorrVecFall)) = 1;
center_part = find(CorrVecFall <= thresh);
CorrVecFall(min(center_part):max(center_part)) = 1;
% smooth correction vecs to avoid "jumps":
CorrVecRise = smooth(CorrVecRise,smooth_span)';
CorrVecFall = smooth(CorrVecFall, smooth_span)';


% Use both ends values
CorrVecBoth = [CorrVecRise(1:(end/2)), CorrVecFall((1+end/2):end)];
% Use symmetric correction vec:
CorrVecSymRise = [CorrVecRise(1:(end/2)), fliplr(CorrVecRise(1:(end/2)))];
CorrVecSymFall = [CorrVecFall(1:(end/2)), fliplr(CorrVecFall(1:(end/2)))];

% Plots (Optional):
% figure;
% subplot(2,3,1); plot( TimeVec, RiseVec, TimeVec, LinVecRise, 'k');
% subplot(2,3,4); plot( TimeVec, CorrVecRise, '.');
% subplot(2,3,2); plot( TimeVec, FallVec, TimeVec, LinVecFall, 'k');
% subplot(2,3,5); plot( TimeVec, CorrVecFall, '.');
% subplot(2,3,6); plot( TimeVec, CorrVecBoth, '.', TimeVec, CorrVecSymRise, '.');

end

