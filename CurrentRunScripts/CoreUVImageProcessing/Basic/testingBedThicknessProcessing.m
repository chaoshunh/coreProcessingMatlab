%%Testing Bedding Thickness Image Processing
%I = imread('363X-16R, core image, UV@166.38 Core 3.png');
%%can put entry point here for a function to use either dilated or full res edge
%%array
[a,b] = size(luminosity_Edges);

%%Faster idea
% Use the luminosity to create an index logical array, screen out diffs
% that are excluded/core parts
luminosityScreen = luminosity > 29;

dblEdges = double(dilatedEdges);
dblEdges(~luminosityScreen) = 0;
%take diff of edge array

diffOfEdges = diff(dblEdges);
luminosityScreen = luminosityScreen(1:length(luminosityScreen) -1,:);
diffOfEdges(~luminosityScreen) = 0;
%count/sum the diffs = rough lam count for each column
sumsOfEdges = sum(abs(diffOfEdges));
[row , column] = find(diffOfEdges);
index = zeros(1,1);
c = length(row);
for x  = 1:b
    screen = column(:,1) == x;
    index(screen,x) = row(screen,1);
end
%Get an index of the locations of the "1s" in the diff array using '[row column] = find' and take a
%diff of the index to get the thickness of the "beds" into a table
%logicalIdx = index > 0;
%index = index(logicalIdx);
%index = index(find(index));
rowDiff = diff(index);
bedThicknesses = rowDiff .*ftPerPix;
bedThicknessesIdx = bedThicknesses > 0;
bedThicknesses = bedThicknesses(bedThicknessesIdx);
histogram(bedThicknesses);