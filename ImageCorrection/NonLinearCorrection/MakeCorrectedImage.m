function [ NewMat, NewMatChangedFlag ] = MakeCorrectedImage( OldMat, CorrVec_Rise, CorrVec_Fall, NumPixels )
%MAKECORRECTEDIMAGE Summary of this function goes here
%   Detailed explanation goes here

NewMat = zeros(NumPixels);              % New "Corrected" Matrix
NewMatChangedFlag = zeros(NumPixels);   % Matrix containing info if NewMat vals were already changed 

for i=(-NumPixels/2):((NumPixels/2)-1)
    ii = i+NumPixels/2+1;
    for j=(-NumPixels/2):((NumPixels/2)-1)
        jj = j+NumPixels/2+1;
        if (mod(ii,2)==1) %odd line, so use Rise Correction Vector
            NewPixelPos_j = round(j./CorrVec_Rise(jj));
        elseif (mod(ii,2)==0) %even line, so use Fall Correction Vector
            NewPixelPos_j = round(j./CorrVec_Fall(jj));
        end
        
        if (NewMatChangedFlag(ii,NewPixelPos_j+NumPixels/2+1)==0) % value was not yet changed
            NewMat(ii,NewPixelPos_j+NumPixels/2+1) = OldMat(ii,jj);
            NewMatChangedFlag(ii,NewPixelPos_j+NumPixels/2+1) = 1; 
        elseif (NewMatChangedFlag(ii,jj)==1) % value was changed before
            tmpval = NewMat(ii,NewPixelPos_j+NumPixels/2+1);
            % then insert the average of all values
            NewMat(ii,NewPixelPos_j+NumPixels/2+1) = 0.5*(tmpval + OldMat(ii,jj));
            % other option (not used): insert sum of values:
%             NewMat(ii,NewPixelPos_j+NumPixels/2+1) = (tmpval + OldMat(ii,jj));
        end
        
    end
end

end

