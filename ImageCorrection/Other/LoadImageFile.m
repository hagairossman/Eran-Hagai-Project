function [ ImageMat ] = LoadImageFile( )
%LOADIMAGEFILE Summary of this function goes here
%   Detailed explanation goes here

% load sample image
[Imfilename, Impathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Select an image',...
          'C:\Users\HR\Documents\GitHub\Eran-Hagai-FinalProj\NewCorrection\ImageCorrection\SampleData\Images\pixelshift-99-99-framerate-2-604fps-160516_001-Ch1.tif');
ImageMat = im2double(imadjust(imread([Impathname, '\', Imfilename])));

end

