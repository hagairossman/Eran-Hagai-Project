function [ TestMat ] = CreateSimulationMat(NumPixels)

TestMat = zeros(NumPixels);
mid = round(NumPixels/2);
h = 8; mult = 8; w = h*mult;
block = repmat([180*ones(h),zeros(h)],[1,mult/2]);

% Create checkerboard
for i = 1:h:(NumPixels-w)
    TestMat(i:(i+size(block,1)-1),i:(i+size(block,2))-1) = block;
    TestMat(i:(i+size(block,1)-1),(NumPixels-w-i):(NumPixels-w-i+size(block,2)-1)) = block;
end

% Create big blocks
TestMat((mid-w/2):(mid+w/2),1:(1+w)) = 50;
TestMat((mid-w/2):(mid+w/2),(NumPixels-(w+1)):(NumPixels)) = 100;
TestMat(1:(1+w),(mid-w/2):(mid+w/2)) = 150;
TestMat((NumPixels-(w+1)):(NumPixels),(mid-w/2):(mid+w/2)) = 200;


end

