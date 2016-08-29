function [ LineSwitchedMat ] = LineSwitching( OddFrame, EvenFrame )
%LINESWITCHING Summary of this function goes here
%   Detailed explanation goes here

LineSwitchedMat = zeros(size(OddFrame));
LineSwitchedMat(1:2:end, :) = OddFrame(1:2:end, :);
LineSwitchedMat(2:2:end, :) = EvenFrame(2:2:end, :);

end

