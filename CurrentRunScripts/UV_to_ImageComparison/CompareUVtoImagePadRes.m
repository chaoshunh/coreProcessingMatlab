%%Comparing UV Luminance to Image Log Pad Resisitivity
clear all

%%Load resisitivity pad info
ResPadFilename = uigetfile('*.txt', 'Select Pad Resistivity File');
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


%%Decimate the image being used for comparison (selected image interval)

%%Filter the image data to the desired interval


%%%TODO: ALSO MAKE A VERSION USING iPOINT shifts as an input%%%



%make a scatterplot of all the data to see if there is any relationship,
%plus make histograms for each category

