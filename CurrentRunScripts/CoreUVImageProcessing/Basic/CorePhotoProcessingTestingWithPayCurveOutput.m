clear all;
%%Image Processing Workflow
%%InputConstants
    %%sample curve interval
    samplesPerFt = 80;
    %%full res samples per ft
    fullResSamplesPerFt = 2000;
    % Well Name
    wellName = '363X-16R';
    %%Conversion
    samplingInterval = round(fullResSamplesPerFt / samplesPerFt);
    %UV or PL
    isUV = true; 
    %Facies/UV brightness categories and cutoffs, part, foam, and fracture
    %screening vals
        %%UV Screening
        UVScreens(1) = imageClassification(); %initialize the UV screening object #1
        UVScreens(1).name = 'PaleGoldFlour'; %Category Name
        UVScreens(1).color = [255 255 0]; %Color in processed(QC) image
        UVScreens(1).colorLimits(1) = colorBounds(255, 0);%RED max/min
        UVScreens(1).colorLimits(2) = colorBounds(255, 0);%GREEN max/min
        UVScreens(1).colorLimits(3) = colorBounds(255, 0);%BLUE max/min
        UVScreens(1).colorLimits(4) = colorBounds(100, 70);%LUMINANCE Index max/min
        
        UVScreens(2) = imageClassification();
        UVScreens(2).name = 'BrightFlour';
        UVScreens(2).color = [255 0 255];
        UVScreens(2).colorLimits(1) = colorBounds(255, 0);
        UVScreens(2).colorLimits(2) = colorBounds(255, 0);
        UVScreens(2).colorLimits(3) = colorBounds(255, 0);
        UVScreens(2).colorLimits(4) = colorBounds(255, 100);
        
        UVScreens(3) = imageClassification();
        UVScreens(3).name = 'Shadowed_Cracked';
        UVScreens(3).color = [0 0 0];
        UVScreens(3).colorLimits(1) = colorBounds(255, 0);
        UVScreens(3).colorLimits(2) = colorBounds(255, 0);
        UVScreens(3).colorLimits(3) = colorBounds(255, 0);
        UVScreens(3).colorLimits(4) = colorBounds(29, 0);
        
        UVScreens(4) = imageClassification();
        UVScreens(4).name = 'No_Flour';
        UVScreens(4).color = [255 255 255];
        UVScreens(4).colorLimits(1) = colorBounds(255, 0);
        UVScreens(4).colorLimits(2) = colorBounds(255, 0);
        UVScreens(4).colorLimits(3) = colorBounds(255, 0);
        UVScreens(4).colorLimits(4) = colorBounds(50, 29);
        
        UVScreens(5) = imageClassification();
        UVScreens(5).name = 'FaintFlour';
        UVScreens(5).color = [0 0 255];
        UVScreens(5).colorLimits(1) = colorBounds(255, 0);
        UVScreens(5).colorLimits(2) = colorBounds(255, 0);
        UVScreens(5).colorLimits(3) = colorBounds(255, 0);
        UVScreens(5).colorLimits(4) = colorBounds(70, 50);
    %image log, depth shifted to core depth
    
%Select Images to Process
images = uigetfile('.png', 'Select Photos', 'MultiSelect', 'on');
%%Load image(s) & Metadata
metadata = uigetfile('.csv', 'Select Metadata', 'MultiSelect', 'on');
AvgLuminosity = zeros(1,2);
[~,a] = size(images);
[~,b] = size(metadata);
totalNumberOfPixels = 0;
totalFaciesSum = zeros(length(UVScreens), 1);
RGBLCurvesAll = zeros(1,5);
PayCurveAll = zeros(1,2);
LamCurveAll = zeros(1,5); %output curve for laminations
%%LOOP Through Each Img
for x = 1:a
    if(a == 1)
        %%There is only one image
        imageData = importPNG(images);
        %%metadata loader goes here
        [~,~,~,ImageType,LightType,TopDepth,BottomDepth,~,~,~,~,~,~,~] = importCorePhotoCSV(metadata);
    else
        %%There are multiple images
        imageData = importPNG(images{1,x});
        %%metadata loader goes here
        [~,~,~,ImageType,LightType,TopDepth,BottomDepth,~,~,~,~,~,~,~] = importCorePhotoCSV(metadata{1,x});
    end
    %%eliminate edges of core (cuts down on foam and broken core
    imageData = applyPixelPad( imageData, 150);
    
    %background = imopen(imageData, strel('line', 25,0));
    %background = multithresh(imageData, 7);
    %seg_I = imquantize(imageData,background);
    
    %background = label2rgb(seg_I);
    
    %imwrite(imageData, 'testProcessedBefore.png');
    %imwrite(seg_I, 'testProcessedAfter.png');
    %%Setup pixel-depth conversion factor
    lengthFt = BottomDepth - TopDepth;
        % Get ImageData size
     [c,d,e] = size(imageData);
     processedImage = zeros(c,d,e);
        %ft per pixel
     ftPerPix = lengthFt/c; 
     
     %%Find Visual Luminosity Factor
    
             %%Perceived Luminance Formula
                % .2126 * R + .7152 * G + .0722 * B
             luminosity= imageData(:,:,1) .* 0.2126 + imageData(:,:,2) .* 0.7152 + imageData(:,:,3) .* 0.0722;
             imageData = uint8(imageData);
             %%Edge Detection
             [luminosity_Edges, threshOut] = edge(luminosity, 'Canny' );
             se = strel('line', 40, 0);
             dilatedEdges = imdilate(luminosity_Edges, se);
             disp(threshOut);
             
             %%put bedding curve analysis here
             %%set sample interval
             sampleInterval = 1; %ft
             sampleSizeInPixels = round(1/ftPerPix);
             %%loop through the edge array run the core lam counter
             %%function
             counter = 0;
             LamCurve = zeros(1,5);
             for v = 1:sampleSizeInPixels:c
                 counter = counter + 1;
                 [  LamCurve(counter, 2), thickness_dist, LamCurve(counter, 3), LamCurve(counter, 4), LamCurve(counter, 5) ] = coreLamCounter( luminosity_Edges, dilatedEdges(v:sampleSizeInPixels,: ));
                 LamCurve(counter, 2) = v * ftPerPix + TopDepth;
             end
             if LamCurveAll(1,1) ~=0
                  LamCurveAll = vertcat( LamCurveAll, LamCurve);
                [~, LamCurveAllIdx ]= sort( LamCurveAll(:,1));
                 LamCurveAll(:,1) =  LamCurveAll( LamCurveAllIdx,1);
                 LamCurveAll(:,2) =  LamCurveAll( LamCurveAllIdx,2);
             else
                  LamCurveAll =  LamCurve;
             end
             
             %[boundaries, Labels] = bwboundaries(luminosity_Edges);
             %boundariesOutput = label2rgb(Labels, @jet, [.5 .5 .5]);
             clear tempLum lumDepth;
             tempLum = sum(luminosity,2);
             tempLum = tempLum ./d;
             lumDepth(:,1) = TopDepth:ftPerPix:BottomDepth;
             if length(lumDepth)~= length( tempLum)
                if length(lumDepth)> length( tempLum)
                    lumDepth2 = lumDepth(1:length( tempLum), 1);
                    lumDepth = lumDepth2;
                clear lumDepth2;
                else
                    lumdepth(length(lumDepth) + 1,1) = lumdepth(length(lumDepth),1) + ftPerPix;
                end
             end
             if length(AvgLuminosity) == 2
                 AvgLuminosity = horzcat(lumDepth,tempLum);
             else
                 tempLum = horzcat(lumDepth,tempLum);
                 AvgLuminosity = vertcat(AvgLuminosity, tempLum);
                 [AvgLuminosity(:,1),idx] = sort(AvgLuminosity(:,1));
                 AvgLuminosity(:,2) = AvgLuminosity(idx,2);
                 
             end
             %%Calculate Cumululative Luminance for each column
             cumulativeLuminosity = cumsum(double(luminosity));
     %%Exlude Bad (Broken) core from processed image & luminosity %%OFF (for
     %%now)
     %[ processedImage, luminosity, BadCore ] = BadCoreRemoveV1( processedImage, luminosity, 'BadCoreDesc.txt' );
        %bad core RGB color
        %load the bad Core flag 
      [ BadCore ] = simpleLoadBadCore( 'BadCoreDesc.txt', ftPerPix, TopDepth);    
    %%UV or PL?     
     if isUV
         faciesSum = zeros(length(UVScreens), 1);
         
         for y = 1:length(UVScreens)
            
             [result, processedImageOutput, faciesSum(y,1)] =  UVScreens(y).vectorCheckValuesAndSimpleProcessImageANDSumANDExcludeBadCore( imageData, luminosity, BadCore);
             hasValsIndex = (processedImageOutput ~= 0) & (processedImage == 0);
             processedImage(hasValsIndex) =+ processedImageOutput(hasValsIndex);
         end

         filename = strcat('processedimage', images{1,x});
         imwrite(processedImage, filename);
        filename = strcat('UVedges', images{1,x});
        imwrite(luminosity_Edges, filename);
        filename = strcat('UVedgesDilated', images{1,x});
        imwrite(dilatedEdges, filename);
%         faciesSum = 0;
%         filename = strcat('UVboundaries', images{1,x});
%         imwrite(boundariesOutput, filename);
%         faciesSum = 0;
     else
         %%(optional: visual description of core to make lithofacies color
        %%histograms)
        filename = strcat('edges', images{1,x});
        imwrite(luminosity_Edges, filename);
        faciesSum = 0;
        %%Also, can use Heutrisitics input from hand/visual description to help
        %%determine lithology in PL analysis
     end
     totalNumberOfPixels = (c*d) + totalNumberOfPixels;
     totalFaciesSum = faciesSum + totalFaciesSum;
     
     
     %%Make pay curve here
     payCurve = zeros(c,2);
        %use processed image to write the script%%%%%
        %create pay category filters (simple and full)
    %raw color info
    red = processedImage(:,:,1) == 255;
    green = processedImage(:,:,2) == 255;
    blue = processedImage(:,:,3) == 255;
    %pale gold
    isPaleGold = red & green & ~blue;
    isPaleGold = double(isPaleGold);
    %bright Fluor
    isBright = red & blue & ~green;
    isBright = double(isBright);
    %no Fluor
    noFluor = red & green & blue;
    
    %noFluor = double(noFluor);
    %excluded
    excluded = ~red & ~green & ~blue;
    %excluded = double(excluded);
    %faint fluor
    faint = blue & ~red & ~green;
    faint = double(faint);
    %non-pay
    nonPay = noFluor | excluded;
    nonPay = double(nonPay);
    %decimate down to one column using a 'most of' algorithm
        %sum each category
        isBrightSum = sum(isBright, 2);
        isPaleGoldSum = sum(isPaleGold, 2);
        faintSum = sum(faint, 2);
        nonPaySum = sum(nonPay, 2);
        %loop through each row and find the category with the largest sum
        for y = 1:c
            payCurve(y,1) = TopDepth + (ftPerPix * (y - 1));
            %assign value to the value/depth curve
            if (isBrightSum(y,1) >= isPaleGoldSum(y,1)) && (isBrightSum(y,1) >= faintSum(y,1)) && (isBrightSum(y,1) >= nonPaySum(y,1))
                payCurve(y,2) = 3;
            elseif (isPaleGoldSum(y,1) >= faintSum(y,1)) && (isPaleGoldSum(y,1) >= nonPaySum(y,1))
                payCurve(y,2) = 2;
            elseif (faintSum(y,1) >= nonPaySum(y,1))
                payCurve(y,2) = 1;
            else
                payCurve(y,2) = 0;
            end
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
     %%Make sampled curve info%%%%%%%%%%%%%%%%
     
     %%decimate image data by sampling interval
      sampledImageData = imageData(1:samplingInterval:c, : , : );
      sampledLuminosity = luminosity(1:samplingInterval:c, :);
      [m,~] = size(sampledImageData);
      sampledImageDataOutput = zeros(m, 5);
     %%calculate horizontal pixel avg & populate output array with sample values for RGBL & depth
     
     for y = 1:m
         for z = 1:3
             sampledImageDataOutput(y,z+1) = mean(sampledImageData(y,:,z));
         end
            sampledImageDataOutput(y,5) = mean(sampledLuminosity(y,:));
            %%Depth Calc
            sampledImageDataOutput(y,1) = TopDepth + (((y - 1) * samplingInterval)) * ftPerPix;
     end
     
     
     %%Vert cat the array for this segment with the previous segments'
     %%arrays (check that the previous segment array length > 1)
     [u,~] = size(RGBLCurvesAll);
     if u == 1
         RGBLCurvesAll = sampledImageDataOutput;
     else
         %%check whether the new data is above or below the previous data,
         %%may need to sort the input images by depth to make this more
         %%robust
         if RGBLCurvesAll(1,1) > sampledImageDataOutput(1,1)
            RGBLCurvesAll = vertcat(sampledImageDataOutput,RGBLCurvesAll);
         else
            RGBLCurvesAll = vertcat(RGBLCurvesAll ,sampledImageDataOutput); 
         end
        
     end
    
     
end

 obsPcts = totalFaciesSum ./ totalNumberOfPixels;
 obsPcts(length(obsPcts) + 1, 1) = 1 - sum(obsPcts); 
 totalPixelHeight = totalNumberOfPixels/d;
 coreHeight = totalPixelHeight * ftPerPix;
 netFT = obsPcts .*coreHeight;
 
 
 %%Output sampled RGBL data to pointwell data format
 fid = fopen('testUV_RGBLSamples.txt', 'w');
 fprintf(fid, 'VERSION 1\nBEGIN HEADER\nWell Name\nMD\nRed\nGreen\nBlue\nLuminance\nEND HEADER\n');
 for x = 1:length(RGBLCurvesAll)
     fprintf(fid, '%s %f %f %f %f %f\n', wellName, RGBLCurvesAll(x,1), RGBLCurvesAll(x,2), RGBLCurvesAll(x,3),RGBLCurvesAll(x,4), RGBLCurvesAll(x,5));
 end
 fclose(fid);

%%Report
if isUV
    report = cell(1,1);
    report{1,1} = 'Core Image Analysis Output Report';
    report{2,1} = 'Inputs';
    report{3,1} = 'ClassificationName';
    report{3,2} = 'RedMax';
    report{3,3} = 'RedMin';
    report{3,4} = 'GreenMax';
    report{3,5} = 'GreenMin';
    report{3,6} = 'BlueMax';
    report{3,7} = 'BlueMin';
    report{3,8} = 'LuminosityMax';
    report{3,9} = 'LuminosityMin';
    [a,~]= size(report);
    for x = 1:length(UVScreens)
        report{a + x,1} = UVScreens(x).name;
        report{a + x,2} = mat2str(UVScreens(x).colorLimits(1).max);
        report{a + x,3} = mat2str(UVScreens(x).colorLimits(1).min);
        report{a+ x,4} = mat2str(UVScreens(x).colorLimits(2).max);
        report{a + x,5} = mat2str(UVScreens(x).colorLimits(2).min);
        report{a + x,6} = mat2str(UVScreens(x).colorLimits(3).max);
        report{a + x,7} = mat2str(UVScreens(x).colorLimits(3).min);
        report{a + x,8} = mat2str(UVScreens(x).colorLimits(4).max);
        report{a + x,9} = mat2str(UVScreens(x).colorLimits(4).min);
    end
    report{a + x + 1,1} = 'Outputs';
    report{a +x+2,1} = 'ClassificationName';
    report{a +x+2,2} = 'Pct of Pixels';
    report{a +x+2,3} = 'Net Ft';
    for y = 1:length(UVScreens) + 1
        if y <= length(UVScreens)
            report{a +x + 2 + y,1} = UVScreens(y).name;
        else
            report{a +x + 2 + y,1} = 'Excluded/Unclassified';
        end
        report{a +x + 2 + y,2} = mat2str(obsPcts(y,1));
        report{a +x + 2 + y,3} = mat2str(netFT(y,1));
    end
    if(~ispc)
        fid = fopen('AnalysisReport.txt', 'w');
        [a,b] = size(report);
        for x = 1:a
            
            for y = 1:b
                fprintf(fid,'%s\t', report{x,y});
                if y==b
                    fprintf(fid, '\n');
                end
            end
        end
        fclose(fid);
    else
        xlswrite('AnalysisReport', report);
    end
else
    %%Non UV Report
    
end

%%Output pay curve
filename = strcat('payCurve',wellName,'.txt');
fid = fopen(filename, 'w');
fprintf(fid, 'VERSION 1\nBEGIN HEADER\nWell Name\nMD\nPay\nEND HEADER\n');

for x = 1:length(PayCurveAll)
    fprintf(fid, '%s %f %1.f\n', wellName, PayCurveAll(x,1), PayCurveAll(x,2));
end
fclose(fid);
%%TODO OUTPUTS

%RGB Histograms for each visually described facies

%RGB UV FLOUR/PL Facies Description per depth ->make this importable to my
%core plots workup script(s) to make awesome plots by facies/fluor analysis

%%percent of pixels for each category over whole core and for 10ft
%%increments

%%IMAGE LOG
%Image luminance/RGB values for both visual and image analyzed categories
%Histograms of image log values for each category
%image log variance from track to track (Hz and vertically)





