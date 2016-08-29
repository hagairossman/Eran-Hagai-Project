function [ OutMat ] = CorrectImage2( ImageMat, NumPixels, CorrVecR, CorrVecF, fix_params)
 
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
mid_amp = fix_params(1);
thresh = fix_params(2);
smooth_span = fix_params(3);
stretch = fix_params(4);
gaussfiltsigma = fix_params(5);
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

