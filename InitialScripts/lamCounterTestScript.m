%%Make separate lam count function

clear all
%%Top interval of interest
topOfInterval = 8565;

%%bottom interval of interest
bottomOfInterval = 8700;

%%load image(s) & metadata
imageData = imread('363X-16R, Log Image, Log Image@100.0.pngsinglePadImage1.png');
[~,~,~,ImageType,LightType,TopDepth,BottomDepth,~,~,~,~,~,~,~] = importCorePhotoCSV('363X-16R, Log Image, Log Image@100.0.csv');
%trim to desired depth range
    %find pixels per ft
lengthFt = BottomDepth - TopDepth;

[c,d,e] = size(imageData);
 processedImage = zeros(c,d,e);
        %ft per pixel
 ftPerPix = lengthFt/c; 
 
 %%trim edges
    %find starting pixel
        %ft = ftPerPix * pixelIndex + startDepth
        %pixelIndex = (ft -startDepth)/ftPerPix
        startingPixel = round((topOfInterval - TopDepth)/ftPerPix);
        endPixel = round((bottomOfInterval - TopDepth)/ftPerPix);
imageData = imageData(startingPixel:endPixel,:,:);
imageData = double(imageData);
%find edges
luminosity= imageData(:,:,1) .* 0.2126 + imageData(:,:,2) .* 0.7152 + imageData(:,:,3) .* 0.0722;
[a,b] = size(luminosity);
%[edgeImage, thresh] = edge(luminosity, 'Canny', [.001 .01]);
%[edgeImage, thresh] = edge(luminosity, 'log', 0);
luminosityDiff = diff(luminosity);
luminosityDiffNonZero = luminosityDiff > 0;
imwrite(uint8(luminosityDiff), 'diffImage.png');
imwrite(luminosityDiffNonZero, 'diffEdges.png');
%[edgeImage, thresh] = edge(luminosity, 'Sobel', .02, 'horizontal');
%checkImage = edgeImage .* 255;
%imwrite(uint8(checkImage),'testingImageEdge2.png');
%convert edges to double
edgeImage = double(luminosityDiffNonZero);
%take diff of edges
diffOfEdges = diff(edgeImage);

%sum the edges

sums = sum(abs(diffOfEdges));
lamCount = round(mean(sums(1:length(sums)-1)) - 1);
%%Reconstruct diff of edges table (only needed for when null values are
%%filtered as in core images with core parts/fracture
[row, column] = find(diffOfEdges ~=0);
index = zeros(1,1);
c = length(row);
for x  = 1:b
    screen = column(:,1) == x;
    index(screen,x) = row(screen,1);
end
%take diff of diff of edges index values
rowDiff = diff(index);
%multiply the diff times ft per pix
bedThicknesses = rowDiff .*ftPerPix;
%screen out zero thickness beds
bedThicknessesIdx = bedThicknesses > 0;
bedThicknesses = bedThicknesses(bedThicknessesIdx);
%plot the bed thickness histogram
%histogram(bedThicknesses);
bedThicknessDist(bedThicknesses, 'Trimmed 363X-16R Bed Thickness Distribution');

savefig(gcf,'363X-trimmed_bedThicknessFigure1');
saveas(gcf, '363X-trimmed_bedThicknessFigure1.jpg');

%%output the lam counts, lam count avg, and bed thicknesses

%%see core UV image script for the rest