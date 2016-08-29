function [ ] = StackVideoCorrection( I, vidFileName, NumPixels, CorrVecR, CorrVecF, fix_params, userDefinedReps )
%Summary of this function goes here
%   Detailed explanation goes here

vid = VideoWriter(vidFileName);
OutMatfileName = [vidFileName(1:end-4), '.mat'];
open(vid); 

L = size(I,3); % num of images in stack
% I_new = zeros(size(I,1),size(I,2),round(size(I,3)/2));
reps = min(L, userDefinedReps);
h = waitbar(0,'Please wait... Correcting Stack');

i = 1;
while (i < reps)
    waitbar(i / reps)
    
    %Take two adjacent frames
    OddFrame = imadjust(im2double(I(:,:,i)));
    EvenFrame = imadjust(im2double(I(:,:,i+1)));
    % Perform line Switching
    [ LineSwitchedMat ] = imadjust(im2double(LineSwitching( OddFrame, EvenFrame )));
    %Obtain Corrected image:
    [ NewMat ] = imadjust(im2double(CorrectImage2( LineSwitchedMat, NumPixels, CorrVecR, CorrVecF, fix_params)));
    % Write to video:
    tmpFrame = [OddFrame ,0.65*ones(size(NewMat,1),200), NewMat];

    I_new(:,:,i) = NewMat;
    writeVideo(vid,tmpFrame);
    
    i = i+2;
end
save(OutMatfileName,'I_new')

close(vid)
close(h) 

end

