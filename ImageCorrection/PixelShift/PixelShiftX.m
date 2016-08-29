function [ OutMat ] = PixelShiftX( InMat, shift )
%PIXELSHIFT Summary of this function goes here
%   Detailed explanation goes here

tmpMat = InMat';
InVec = tmpMat(:)';
OutVec = circshift(InVec, [0,shift]);
OutMat = zeros(size(InMat));
for i = 1:size(InMat,1)
    OutMat(i,:) = OutVec(1:size(InMat,2))';
    OutVec(1:size(InMat,2)) = [];
end

end

