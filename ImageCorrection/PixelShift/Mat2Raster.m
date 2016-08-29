function [ RasterMat ] = Mat2Raster( InputMat )
%MAKERASTERLISTRROMIMAGE Summary of this function goes here
%   Detailed explanation goes here

OddMat = InputMat(1:2:end,:);
EvenMat = fliplr(InputMat(2:2:end,:));
RasterMat = [OddMat, EvenMat];

end

