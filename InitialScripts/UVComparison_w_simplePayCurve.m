%%363X-16R UV photo comparison
clear all;
%%Load UV vs UV 
%load UV images
images = uigetfile({'*.png';'*.tif'}, 'Select 1st UV Photos', 'MultiSelect', 'on');
images = sort(images);
images2 = uigetfile({'*.png';'*.tif'}, 'Select 2nd UV Photos', 'MultiSelect', 'on');
images2 = sort(images2);
%%Load processed UV Images
ProcessedImages = uigetfile({'*.png';'*.tif'}, 'Select Processed UV Photos', 'MultiSelect', 'on');
ProcessedImages = sort(ProcessedImages);
PayCurveAll = zeros(1,2);


[~,t] = size(images);
metadata = cell(1,t);
metadata2 = cell(1,t);
%create metadata strings
for x = 1:t
    metadata{1,x} = strrep(images{1,x},'.png','.csv');
    metadata2{1,x} = strrep(images2{1,x},'.png','.csv');
end
%[~,u] = size(metadata);

%output summary
summary = cell(1,1);
summary{1,1} = 'Total Pixel Count';
summary{2,1} = 0;
summary{3,1} = 'Lost Fluor Pixels';
summary{4,1} = 0;
summary{5,1} = 'Gained Fluor Pixels';
summary{6,1} = 0;


summary{1,2} = 'Bright Fluor Pixel Count';
summary{2,2} = 0;
summary{3,2} = 'Lost Fluor Pixels';
summary{4,2} = 0;
summary{5,2} = 'Gained Fluor Pixels';
summary{6,2} = 0;


summary{1,3} = 'Medium/Gold Fluor Pixel Count';
summary{2,3} = 0;
summary{3,3} = 'Lost Fluor Pixels';
summary{4,3} = 0;
summary{5,3} = 'Gained Fluor Pixels';
summary{6,3} = 0;

summary{1,4} = 'Faint Fluor Pixel Count';
summary{2,4} = 0;
summary{3,4} = 'Lost Fluor Pixels';
summary{4,4} = 0;
summary{5,4} = 'Gained Fluor Pixels';
summary{6,4} = 0;


summary{1,5} = 'No Fluor Pixel Count';
summary{2,5} = 0;
summary{3,5} = 'Lost Fluor Pixels';
summary{4,5} = 0;
summary{5,5} = 'Gained Fluor Pixels';
summary{6,5} = 0;


summary{1,6} = 'Excluded Pixel Count';
summary{2,6} = 0;

summary{1,7} = 0;
for x = 1:t
    %load images
I_1 = imread(images{1,x});
I_2 = imread(images2{1,x});
I_3 = imread(ProcessedImages{1,x});


%load metadata
[~,~,~,~,~,TopDepth_1,BottomDepth_1,~,~,~,~,~,~,~] = importCorePhotoCSV(metadata{1,x});
[~,~,~,~,~,TopDepth_2,BottomDepth_2,~,~,~,~,~,~,~] = importCorePhotoCSV(metadata2{1,x});
%calculate ft per pix for each photo
[a,e,~] = size (I_1);
[b,f,~] = size (I_2);

trimDiff = e - f;
%equalize the width, trim edges
I_1 = applyPixelPad( I_1, 150);

if abs(trimDiff) > 1
    if rem(abs(trimDiff), 2) ~=0
        I_2 = I_2(:,1:f-1,:);
        trimDiff = trimDiff + 1;
        f = f - 1;
        
    end
        I_2 = applyPixelPad( I_2, 150 - (trimDiff / 2));
    
else
    I_2 = I_2(:,1:e,:);
    I_2 = applyPixelPad( I_2, 150);
end
if a >= b
    I_1 = I_1(1:b,:,:);
    I_3 = I_3(1:b,:,:);
    a = b;
    TopDepth = TopDepth_2;
    BottomDepth = BottomDepth_2;
elseif b > a
    I_2 = I_2(1:a,:,:);
    b = a;
    TopDepth = TopDepth_1;
    BottomDepth = BottomDepth_1;
else
    
end

ftOfPhoto1 = BottomDepth_1 - TopDepth_1;
ftOfPhoto2 = BottomDepth_2 - TopDepth_2;
ftPerPix1 = ftOfPhoto1/a;
ftPerPix2 = ftOfPhoto1/b;
ftPerPix = (BottomDepth - TopDepth)/a;
[~,g,~] = size(I_2);
searchDist = 0.15; %ft
searchPixels = round(searchDist / ftPerPix1);
shiftLog = zeros(1,3); %shifts (in 5ft intervals as indicated by match size)
matchSize = 3; %ft
matchPixels = round(matchSize  / ftPerPix1);

%convertImages to luminosity
I_1_lum = I_1(:,:,1) .* 0.2126 + I_1(:,:,2) .* 0.7152 + I_1(:,:,3) .* 0.0722;
I_2_lum = I_2(:,:,1) .* 0.2126 + I_2(:,:,2) .* 0.7152 + I_2(:,:,3) .* 0.0722;
%%TRY: try subtracting unshifted image luminosities from each other, then
%%process into a color unit8 image
I_1_trimmed = I_1_lum(1:a,:);
I_1_trimmed = double(I_1_trimmed);
I_2_lumdbl = double(I_2_lum(1:a,:));
rawLumDiff = I_1_trimmed - I_2_lumdbl;

%rawLumisZero = rawLumDiff == 0;
rawLumBelowZero = rawLumDiff < 0;
rawLumAboveZero = rawLumDiff > 0;



%%Generate Processed Image Category Logical Arrays
    %raw color info
    red = I_3(:,:,1) == 255;
    green = I_3(:,:,2) == 255;
    blue = I_3(:,:,3) == 255;
    %pale gold
    isPaleGold = red & green & ~blue;
    isPaleGoldGained = isPaleGold & rawLumBelowZero;
    isPaleGoldLost = isPaleGold & rawLumAboveZero;
    %bright Fluor
    isBright = red & blue & ~green;
    isBrightGained = isBright & rawLumBelowZero;
    isBrightLost =  isBright & rawLumAboveZero;
    %no Fluor
    noFluor = red & green & blue;
    noFluorGained = noFluor & rawLumBelowZero;
    noFluorLost = noFluor & rawLumAboveZero;
    %excluded
    excluded = ~red & ~green & ~blue;
    %faint fluor
    faint = blue & ~red & ~green;
    faintGained = faint & rawLumBelowZero;
    faintLost = faint & rawLumAboveZero;
    
    %not categorized
    notCategorized = ~isPaleGold & ~isBright & ~excluded & ~noFluor & ~faint;
    notCategorized = double(notCategorized);
    notCategorizedSum = sum(notCategorized);
    notCategorizedSum = sum(notCategorizedSum);
    summary{1,7} = summary{1,7} + notCategorizedSum;
    nonPay = excluded | rawLumBelowZero;
    isPay = ~excluded & rawLumAboveZero;
    
    nonPay = double(nonPay);
    isPay = double(isPay);
    

isPaySum = sum(isPay, 2);
nonPaySum = sum(nonPay, 2);

%%Make pay curve here
payCurve = zeros(a,2);


%loop through each row and find the category with the largest sum
for y = 1:a
    payCurve(y,1) = TopDepth_1 + (ftPerPix1 * (y - 1));
    %assign value to the value/depth curve
    payCurve(y,2) = isPaySum(y,1) / g;
%     if (isPaySum(y,1) > nonPaySum(y,1))
% %         payCurve(y,2) = 1;
%           payCurve(y,2) = isPaySum(y,1) / f;
%     else
% %         payCurve(y,2) = 0;
%         payCurve(y,2) = nonPaySum(y,1) / f;
%     end
end
%vert cat the value depth curve (export to point well file below)
if PayCurveAll(1,1) ~=0
    PayCurveAll = vertcat(PayCurveAll,payCurve);
    [~,PayCurveAllIdx ]= sort(PayCurveAll(:,1));
    PayCurveAll(:,1) = PayCurveAll(PayCurveAllIdx,1);
    PayCurveAll(:,2) = PayCurveAll(PayCurveAllIdx,2);
else
    PayCurveAll = payCurve;
end
%total pixel count    
[sizeX,sizeY, ~] = size(I_3);
totalPixelCount = sizeX * sizeY;
summary{2,1} = summary{2,1}  + totalPixelCount;
%total pixels gained
rawLumBelowZero = double(rawLumBelowZero);
totalGained = sum(rawLumBelowZero);
totalGained = sum(totalGained);
%total pixels lost
rawLumAboveZero = double(rawLumAboveZero);
totalLost = sum(rawLumAboveZero);
totalLost = sum(totalLost);

%Add to summary
summary{4,1} = summary{4,1}  + totalLost;
summary{6,1} = summary{6,1}  + totalGained;

%pale gold fluor pixel counts
isPaleGold = double(isPaleGold);
paleGoldSum = sum(isPaleGold);
paleGoldSum = sum(paleGoldSum);

isPaleGoldGained =  double(isPaleGoldGained);
paleGoldGainedSum = sum(isPaleGoldGained);
paleGoldGainedSum = sum(paleGoldGainedSum);

isPaleGoldLost =  double(isPaleGoldLost);
paleGoldLostSum = sum(isPaleGoldLost);
paleGoldLostSum = sum(paleGoldLostSum);
%add to summary
summary{2,3} = summary{2,3} + paleGoldSum;
summary{4,3} = summary{4,3} + paleGoldLostSum;
summary{6,3} = summary{6,3} + paleGoldGainedSum;

%bright fluor pixel counts
isBright = double(isBright);
brightSum = sum(isBright);
brightSum = sum(brightSum);

isBrightGained =  double(isBrightGained);
brightGainedSum = sum(isBrightGained);
brightGainedSum = sum(brightGainedSum);

isBrightLost =  double(isBrightLost);
brightLostSum = sum(isBrightLost);
brightLostSum = sum(brightLostSum);
%add to summary
summary{2,2} = summary{2,2} + brightSum;
summary{4,2} = summary{4,2} + brightLostSum;
summary{6,2} = summary{6,2} + brightGainedSum;


%faint fluor pixel counts
faint = double(faint);
faintSum = sum(faint);
faintSum = sum(faintSum);

faintGained =  double(faintGained);
faintGainedSum = sum(faintGained);
faintGainedSum = sum(faintGainedSum);

faintLost =  double(faintLost);
faintLostSum = sum(faintLost);
faintLostSum = sum(faintLostSum);
%add to summary
summary{2,4} = summary{2,4} + faintSum;
summary{4,4} = summary{4,4} + faintLostSum;
summary{6,4} = summary{6,4} + faintGainedSum;


%no fluor pixel counts
noFluor = double(noFluor);
noFluorSum = sum(noFluor);
noFluorSum = sum(noFluorSum);

noFluorGained =  double(noFluorGained);
noFluorGainedSum = sum(noFluorGained);
noFluorGainedSum = sum(noFluorGainedSum);

noFluorLost =  double(noFluorLost);
noFluorLostSum = sum(noFluorLost);
noFluorLostSum = sum(noFluorLostSum);

%%Excluded Pixel count
excluded = double(excluded);
excludedSum = sum(excluded);
excludedSum = sum(excludedSum);
summary{2,6} = summary{2,6} + excludedSum;
%add to summary
summary{2,5} = summary{2,5} + noFluorSum;
summary{4,5} = summary{4,5} + noFluorLostSum;
summary{6,5} = summary{6,5} + noFluorGainedSum;

rawLumDiffImage = zeros(a,g,3);
rawLumDiffImage(:,:,1) = 255 .* rawLumBelowZero;
rawLumDiffImage(:,:,2) = 255 .* rawLumAboveZero;

rawLumDiffImage = uint8(rawLumDiffImage);

filename = strcat(images{1,x}, 'rawLuminosityTestOutput.png');
imwrite(rawLumDiffImage, filename);
end

%%Output pay curve
filename = strcat('payCurve','363X-16UVComp','.txt');
fid = fopen(filename, 'w');
fprintf(fid, 'VERSION 1\nBEGIN HEADER\nWell Name\nMD\nPay\nEND HEADER\n');

for x = 1:length(PayCurveAll)
    fprintf(fid, '%s %f %.2f\n', '363X-16R', PayCurveAll(x,1), PayCurveAll(x,2));
end
fclose(fid);