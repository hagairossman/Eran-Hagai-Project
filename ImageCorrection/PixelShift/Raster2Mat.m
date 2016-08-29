function [ OutMat ] = Raster2Mat( RasterMat )
%MAKERASTERLISTRROMIMAGE Summary of this function goes here
%   Detailed explanation goes here

N = size(RasterMat,1)*2;
OutMat = zeros(N);
OutMat(1:2:end,:) = RasterMat( :, 1:N );
OutMat(2:2:end,:) = fliplr(RasterMat( :, (N+1):(2*N) ));

end

