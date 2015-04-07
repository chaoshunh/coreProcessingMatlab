%%Comparing UV Luminance to Image Log Pad Resisitivity
clear all

%%Load resisitivity pad info
ResPadFilename = uigetfile('*.txt', 'Select Pad Resistivity File');
%Load Luminosity Cuttoffs inputs
luminosityInputs = uigetfile('*.txt', 'Select luminosity cuttoffs input');
lumCutoffs = simpleTabImport(luminosityInputs);
%load iPoint shifts info
try
shiftsFile = uigetfile('*.csv', 'Select ipoint Core Shifts Info .csv');
shifts = simpleCSVImport(shiftsFile);
[a,~] = size(shifts);
shifts = shifts(5:a,:);
shifts = str2double(shifts);
clear a;
catch err
    warndlg('Warning! shifts file not loaded, unrecognized format.');
    
end
clear shiftsFile;
try
[ resPadFileOutput ] = simpleTabImport( ResPadFilename);
clear ResPadFilename;
[a,b] = size(resPadFileOutput);
catch err
    disp('ERROR: Pad resistivity file did not load');
    %ME = MException('Resistivity File Format not valid', ...
        %'File %s not loadable',ResPadFilename);
    throw(err);
end
try
columnNames = resPadFileOutput(1,:);
%resData = zeros(a,b);
resData = resPadFileOutput(2:a,:);
resData = str2double(resData);
clear resPadFileOutput;
catch err
    disp('ERROR: Pad resistivity file format not recognized');
    %ME = MException('Resistivity File Format not valid', ...
        %'File %s not loadable',ResPadFilename);
    throw(err);
end
%Load or grandfather in UV luminance data from another script
images = uigetfile({'*.png;*.tif;*.jpg;', 'Image Files (png, tif,jpg'},'Select Processed Image Files', 'MultiSelect', 'on');
%make sure that a single image selection will still work in the script
if ~iscell(images)
    images = {images};
end
%load the metadata for the images
%create metadata strings
t = length(images);

%%Total Image data
allPlot = zeros(1,2);
for x = 1:t
    
    metadata{1,x} = strrep(images{1,x},'.png','.csv');
    metadata{1,x} = strrep(metadata{1,x},'processedimage','');
    metadata{1,x} = strrep(metadata{1,x},'.tif','.csv');
end
%%sort images to make sure they are in order
[metadata, idx] = sort(metadata);
images = images(idx);
%%Upscale UV data to the scale of the resisitivity pad data
padVertResolution = resData(2,1) - resData(1,1);
resStart = resData(1,1);
% %load iPoint shifts info
% shiftsFile = uigetfile('*.csv', 'Select ipoint Core Shifts Info .csv');

for x = 1:length(images)
%%load image
imageData = imread(images{1,x});
[~,~,~,~,~,TopDepth,BottomDepth,~,~,~,~,~,~,~] = importCorePhotoCSV(metadata{1,x});
%Find initial shift
count = 0;
imageToLogShifts = zeros(1,2);
found = false;
ftPerPix = (BottomDepth - TopDepth)/size(imageData,1);
for y = 1:length(shifts)
    if shifts(y,2) > 40
        disp('Skipping a shift with >40ft size');
        continue;
    end
    if (shifts(y,1) >= TopDepth) && (y ~= 1)
         if shifts(y-1,2) > 40
        disp('Skipping a shift with >40ft size');
            stepBack = 2;
         else
             stepBack = 1;
         end
    
        count = count + 1;
        found = true;
        imageToLogShifts(count,1) = shifts(y-stepBack ,1);
        imageToLogShifts(count,2) = shifts(y-stepBack ,2);
        break;
    end
end
if ~found
    shiftDiffs = zeros(1,1);
    for y = 1:length(shifts)
        if shifts(y,2) > 40
            disp('Skipping a shift with >40ft size');
            continue;
        end
        shiftDiffs(y,1) = TopDepth - shifts(y,1);
        if shiftDiff(y,1) < 0
            shiftDiffs(y,1) = 100000;
        end
    end
    [~,I] = min(shiftDiffs);
    count = count + 1;
   imageToLogShifts(count,1) = shifts(I,1);
   imageToLogShifts(count,2) = shifts(I,2);
end
%%find number of shifts contained in the image interval

for y = 1:length(shifts)
    if shifts(y,2) > 40
        disp('Skipping a shift with >40ft size');
        continue;
    end
    if (shifts(y,1) >= TopDepth) && (shifts(y,1) <= BottomDepth)
        count = count + 1;
        imageToLogShifts(count,1) = shifts(y,1);
        imageToLogShifts(count,2) = shifts(y,2);
    end
end
lastPixelShift = 0;
for y = 1:count  
%%Filter the core image data to the desired interval
%start of shift
shiftStartPixels = round(( imageToLogShifts(y,1) -  TopDepth) / ftPerPix);
if shiftStartPixels <= 0
    startCoreDepth = TopDepth;
    shiftStartPixels = 1;
elseif (shiftStartPixels > size(imageData,1)) && (y == 1)
   startCoreDepth = TopDepth;
   shiftStartPixels = 1; 
else
    startCoreDepth = imageToLogShifts(y,1);
end
%end of shift
if y == count
  shiftEndPixels = size(imageData,1);
  endCoreDepth = BottomDepth;
else
  shiftEndPixels = round((imageToLogShifts(y+1,1) - TopDepth) / ftPerPix);
  endCoreDepth = imageToLogShifts(y+1,1);
end
selectedImageData = imageData(shiftStartPixels:shiftEndPixels,:,:);
%get equivalent image log pad data
logStartDepth = startCoreDepth + imageToLogShifts(y,2);

if y == count
    logEndDepth = endCoreDepth + imageToLogShifts(y,2);
else
    logEndDepth = endCoreDepth + imageToLogShifts(y+1,2);
end
startFound = false;
endFound = false;
for z = 1:length(resData)
    if startFound && endFound
        break;
    end
    if (resData(z,1) > logStartDepth) && ~startFound
        resStartIndex = z;
        startFound = true;
    end
    if (resData(z,1) > logEndDepth) && ~endFound
        resEndIndex = z;
        endFound = true;
    end
    
end
if ~endFound
    resEndIndex = z;
end
selectedImageLogData = resData(resStartIndex:resEndIndex, :);
%%Decimate the image being used for comparison (selected image interval)
scale = ftPerPix / padVertResolution;
resizedSelectedImageData = imresize(selectedImageData,scale);
%convert to luminosity
luminosity= resizedSelectedImageData(:,:,1) .* 0.2126 + resizedSelectedImageData(:,:,2) .* 0.7152 + resizedSelectedImageData(:,:,3) .* 0.0722;

%size the luminosity to the image log data
luminositySize = size(luminosity,1);
resistivitySize = size(selectedImageLogData, 1);
if luminositySize > resistivitySize
    luminosity = luminosity(1:resistivitySize, :);
elseif luminositySize < resistivitySize
    selectedImageLogData = selectedImageLogData(1:luminositySize, :);
end

%QC: Plot image resistivity vs. luminosity index
%scatter(luminosity(:,round(size(luminosity,2)/2)), selectedImageLogData(:,2));
clear currentPlot;
currentPlot(:,1) = double(luminosity(:,round(size(luminosity,2)/2)));
currentPlot(:,2) = selectedImageLogData(:,2);

if allPlot(1,1) == 0
    allPlot = currentPlot;
else
    allPlot = vertcat(currentPlot, allPlot);
end
%accumulate the results into results arrays for unified plotting

end

end

%%%TODO: ALSO MAKE A VERSION USING iPOINT shifts as an input%%%



%make a scatterplot of all the data to see if there is any relationship,
%plus make histograms for each category
[  luminosityFilteredIndicies ] = filterOnLuminosity( allPlot(:,1), lumCutoffs );
%scatter(allPlot(:,1), allPlot(:,2));
%scatter(allPlot(luminosityFilteredIndicies(:,2),1), allPlot(luminosityFilteredIndicies(:,2),2));
