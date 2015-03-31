function [ imageData ] = applyPixelPad( imageData, pixelPad)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[a,b,c] = size(imageData);
outputImageData = zeros(a,b-pixelPad*2, c);
count = 0;
for x = pixelPad:1:b-pixelPad
    count = count + 1;
    outputImageData(:,count,:) = imageData(:,x,:);
end
%for x = b:-1:b - pixelPad
%    imageData(:,x,:) = [];
%end
%for x = 1:pixelPad
 %   imageData(:,x,:) = [];
%end
imageData = outputImageData;

end

