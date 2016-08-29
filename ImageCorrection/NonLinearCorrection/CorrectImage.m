function [ OutMat ] = CorrectImage( ImageMat, NumPixels, FrameRate, CropPercentage, Galvofilename, fix_params)
 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Load galvo scope data
load(Galvofilename); 
%Make Rise and Fall vecs:
[ RiseVec, FallVec, TimeVec ] = MakeScanVectors( R_time, R_voltage, F_time, F_voltage, NumPixels );
%% load fix parameters
% Reminder: fix_params = [mid_amp, thresh, smooth_span, stretch, gaussfiltsigma];
mid_amp = fix_params(1);
thresh = fix_params(2);
smooth_span = fix_params(3);
stretch = fix_params(4);
gaussfiltsigma = fix_params(5);

%% Correction Part
% Make Linear  and Correction vectors
[ CorrVecRiseRaw, CorrVecFallRaw, CorrVecRise, CorrVecFall, CorrVecBoth, CorrVecSymRise, CorrVecSymFall, LinVecRise, LinVecFall ] = MakeCorrectionVectors( RiseVec, FallVec, TimeVec, NumPixels, fix_params );
%Chosen Correction Vector style:
CorrVecR = CorrVecSymRise;
CorrVecF = CorrVecSymRise;
% Correct Image
[ OutMat, tmpMatChangedFlag ] = MakeCorrectedImage( ImageMat, CorrVecR, CorrVecF, NumPixels ); %Make New "Corrected" Matrix
%Stretch Image
if (stretch>0) %otherwise dont apply
    [ OutMat ] = StretchImage( OutMat,tmpMatChangedFlag, NumPixels );
end
% Apply Gausiian filter:
if (gaussfiltsigma>0) %otherwise dont apply
    OutMat = imgaussfilt(OutMat,gaussfiltsigma);
end

end

