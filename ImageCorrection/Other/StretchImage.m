function [ StrechedMat ] = StretchImage( InMat,InMatChangedFlag, NumPixels )
%STRETCHIMAGE Summary of this function goes here
%   Detailed explanation goes here

crop_low = find(InMatChangedFlag(1,:) == 1, 1, 'first');
crop_high = find(InMatChangedFlag(1,:) == 1, 1, 'last');

StrechedMat = InMat(:, crop_low:crop_high);
StrechedMat = imresize(StrechedMat, [NumPixels, NumPixels]);

end

