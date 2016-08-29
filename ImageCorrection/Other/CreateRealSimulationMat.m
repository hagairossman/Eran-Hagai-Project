function [ SimMat ] = CreateSimulationMat(NumPixels)

%% Create Good Mat
TestMat = zeros(NumPixels);
mid = round(NumPixels/2);
h = 8; mult = 8; w = h*mult;
block = repmat([255*ones(h),zeros(h)],[1,mult/2]);

% Create checkerboard
for i = 1:h:(NumPixels-w)
    TestMat(i:(i+size(block,1)-1),i:(i+size(block,2))-1) = block;
    TestMat(i:(i+size(block,1)-1),(NumPixels-w-i):(NumPixels-w-i+size(block,2)-1)) = block;
end

% Create big blocks
% TestMat((mid-w/2):(mid+w/2),w:(1+2*w)) = 50;
% TestMat((mid-w/2):(mid+w/2),(NumPixels-(2*w+1)):(NumPixels-w)) = 100;
TestMat(1:(1+w),(mid-w/2):(mid+w/2)) = 150;
TestMat((NumPixels-(w+1)):(NumPixels),(mid-w/2):(mid+w/2)) = 200;

%% Anti-Correct Image
% load([pwd, '\SampleData\CorrVecs\5_04.mat']);
% 
% % Balagan
% CorrVec_Rise = CorrVec; CorrVec_Fall = CorrVec;
% newNumPixels = round(max(CorrVec)*NumPixels);
% OldMat = TestMat;
% NewMat = zeros(newNumPixels, newNumPixels);             % New "Corrected" Matrix
% NewMatChangedFlag = zeros(newNumPixels, newNumPixels);   % Matrix containing info if NewMat vals were already changed 
% 
% for i=(-NumPixels/2):((NumPixels/2)-1)
%     ii = i+NumPixels/2+1;
%     for j=(-NumPixels/2):((NumPixels/2)-1)
%         jj = j+NumPixels/2+1;
%         if (mod(ii,2)==1) %odd line, so use Rise Correction Vector
%             NewPixelPos_j = round(j.*CorrVec_Rise(jj));
%         elseif (mod(ii,2)==0) %even line, so use Fall Correction Vector
%             NewPixelPos_j = round(j.*CorrVec_Fall(jj));
%         end
%         
%         tst = NewPixelPos_j+newNumPixels/2+1;
%         
%         if (NewMatChangedFlag(ii,NewPixelPos_j+newNumPixels/2+1)==0) % value was not yet changed
%             NewMat(ii,NewPixelPos_j+newNumPixels/2+1) = OldMat(ii,jj);
%             NewMatChangedFlag(ii,NewPixelPos_j+newNumPixels/2+1) = 1; 
%         elseif (NewMatChangedFlag(ii,jj)==1) % value was changed before
%             tmpval = NewMat(ii,NewPixelPos_j+newNumPixels/2+1);
%             % then insert the average of all values
%             NewMat(ii,NewPixelPos_j+newNumPixels/2+1) = 0.5*(tmpval + OldMat(ii,jj));
%             % other option (not used): insert sum of values:
% %             NewMat(ii,NewPixelPos_j+NumPixels/2+1) = (tmpval + OldMat(ii,jj));
%         end
%         
%     end
% end


%% Perform Pixel Shift
NewMat = TestMat;
shift = 100;
[ RasterMat ] = Mat2Raster( NewMat );
[ OutMatRastered ] = PixelShiftX( RasterMat, shift );
[ OutMat ] = Raster2Mat( OutMatRastered );

%% Crop
mid = size(OutMat,1)/2;
left = mid - (NumPixels/2)+1;
right = mid + (NumPixels/2);
%crop
SimMat = OutMat(1:NumPixels, left:right);

end

