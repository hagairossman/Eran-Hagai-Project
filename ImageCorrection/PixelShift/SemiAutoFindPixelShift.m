function [ X_ShiftVal, Y_ShiftVal ] = SemiAutoFindPixelShift( ImageMat )
%SEMIAUTOPIXELSHIFT Summary of this function goes here
%   Detailed explanation goes here

% PixelShift SemiAutoFind

% Split into Odd & Even only sub-images
I_odd = ImageMat(1:2:end,:);
I_even = ImageMat(2:2:end,:);

% get user window
% imshow(I_even );
% figure; image(ImageMat,'CDataMapping', 'scaled'); title('Before - Original Image'); axis equal;
figure(9); image(I_even,'CDataMapping', 'scaled'); title('Select feauture for Cross-Correlation'); axis equal; colormap(jet(255));
pos = getrect; % [xmin ymin width height]
close(figure(9));

% crop user defined window
window = imcrop(I_even, pos);
% win = I_even( pos(1):(pos(1)+pos(3)) , pos(2):(pos(2)+pos(3));
% imshow(window);

% Correlation & SSD
[I_SSD,I_NCC,Idata]=template_matching(window, I_odd);

% Find maximum correspondence in I_SSD image
%  [y,x]=find(I_SSD==max(I_SSD(:))); % SSD method
[y,x]=find(I_NCC==max(I_NCC(:)));    % Cross-Correlation method
% calculate shifts
xshift = round(pos(1)+pos(3)/2)-x;
yshift = round(pos(2)+pos(4)/2)-y;
shifts = [xshift, yshift];
% position for new window
pos_new = pos + [(-xshift), (-yshift), 0, 0];

% Output shift vals:
X_ShiftVal = round(xshift/2);
Y_ShiftVal = round(yshift/2);

end

