%%NMR Analysis Add on script to core workup script
%  clear all;
%%UNCOMMENT IF STARTING FRESH%%%%%%%%__________________
%   [ faciesDataArray, numberOfFaciesCodes, MD_Core,Facies_CoreDepth ] = dataPrep( );
%  startingArrayWidth = size(faciesDataArray(1,1).logData,2);
%______________________________

%%Load NMR Data into Facies Data Array
%UNCOMMENT IF STARTING FRESH%%%%%%%%_____________
% NMRFile = uigetfile('*.txt', 'Select NMR Input File');
% NMRData = simpleTabImport(NMRFile);
% NMRData = NMRData(2:size(NMRData,1), :);
% NMRData = str2double(NMRData);

%_________________________
for x = 1:size(NMRData,1)
    %check data is in range to reduce time spent looping
    plzContinue = true;
    for y = 1:size(faciesDataArray,1)
        if NMRData(x,1) < min(faciesDataArray(y,1).logData(:,1)) || NMRData(x,1) > max(faciesDataArray(y,1).logData(:,1))
             
                continue;
                
            
        end
        plzContinue = false;
        break;
    end
    if plzContinue
        continue;
    end
    %disp('searching for match!');
    for y = 1:size(faciesDataArray,1)
        %%Populate Facies Log Array
        for z = 1:size(faciesDataArray(y,1).logData, 1)
            if NMRData(x,1) == faciesDataArray(y,1).logData(z,1)
                if startingArrayWidth == size(faciesDataArray(y,1).logData,2);
                    faciesDataArray(y,1).logData(z,size(faciesDataArray(y,1).logData,2) + 1) =  NMRData(x,2);
                    faciesDataArray(y,1).logData(z,size(faciesDataArray(y,1).logData,2) + 2) =  NMRData(x,3);
                    faciesDataArray(y,1).logData(z,size(faciesDataArray(y,1).logData,2) + 3) =  NMRData(x,4);
                    faciesDataArray(y,1).logData(z,size(faciesDataArray(y,1).logData,2) + 4) =  NMRData(x,5);
                    disp('Found Location for NMR data in log array!');
                else
                    faciesDataArray(y,1).logData(z,startingArrayWidth + 1) =  NMRData(x,2);
                    faciesDataArray(y,1).logData(z,startingArrayWidth + 2) =  NMRData(x,3);
                    faciesDataArray(y,1).logData(z,startingArrayWidth + 3) =  NMRData(x,4);
                    faciesDataArray(y,1).logData(z,startingArrayWidth + 4) =  NMRData(x,5);
                    disp('Found Location for NMR data in log array!');
                end
                break;
            end
        end
%         for z = size(faciesDataArray(y,1).shiftedLog_PlugData, 1)
%             if NMRData(z,1) == faciesDataArray(y,1).shiftedLog_PlugData(z,1)
%                 faciesDataArray(y,1).shiftedLog_PlugData(z,size(faciesDataArray(y,1).shiftedLog_PlugData,2) + 1) =  NMRData(z,2);
%                 faciesDataArray(y,1).shiftedLog_PlugData(z,size(faciesDataArray(y,1).shiftedLog_PlugData,2) + 2) =  NMRData(z,3);
%                 faciesDataArray(y,1).shiftedLog_PlugData(z,size(faciesDataArray(y,1).shiftedLog_PlugData,2) + 3) =  NMRData(z,4);
%                 faciesDataArray(y,1).shiftedLog_PlugData(z,size(faciesDataArray(y,1).shiftedLog_PlugData,2) + 4) =  NMRData(z,5);
%                 disp('Found Location for NMR data in shifted log and plug array!');
%                 break;
%             end
%         end
    end
end


%%Make NMR basic histograms

for y = 1:size(faciesDataArray,1)
    if y ~=7
histogram(faciesDataArray(y,1).logData(:,18),'BinWidth',0.002);
xlim(gca,[0 0.1]);
titleStr = strcat('NMR Free Fluid Volume for Facies Code ', mat2str(y));
title({titleStr});
filename = strcat('FFV_faciesCode_', mat2str(y), '.fig');
saveas(gcf, filename);
close(gcf);
    end
end
%%Plot NMR info with PEF/Density 

for y = 1:size(faciesDataArray,1)
    if y ~=7
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','YDir','reverse');
%scatter(faciesDataArray(y,1).logData(:,6),faciesDataArray(y,1).logData(:,3),[],faciesDataArray(y,1).logData(:,18));
titleStr = strcat('NMR Free Fluid Volume and PEF Lithodensity for Facies Code ', mat2str(y));
title({titleStr});
filename = strcat('PEF_NMR_', mat2str(y), '.fig');
xlim(axes1,[1 5]);
ylim(axes1,[2.2 2.8]);
hold(axes1,'on');
scatter(faciesDataArray(y,1).logData(:,6),faciesDataArray(y,1).logData(:,3),[],faciesDataArray(y,1).logData(:,18));
colorbar('peer',gca,'Limits',[0 0.1]);
hold(axes1,'off');
saveas(gcf, filename);
close(gcf);
    end
end
%NMR & Pickett Plots
%%%TODO

%%Plot NMR FFV vs %sand/silt over the 24in static vert. resolution
%%TODO:Make a sep. function, feed it NMR + Core Description + Tool Res
descFile = uigetfile('*.txt', 'Select Core Desc Input File');
DescData = simpleTabImport(descFile);

for x = 2:size(DescData, 1)
    coreDescLogDepth(x-1,1) = str2double(DescData{x,3});
    coreDescLogDepth(x-1,2) = str2double(DescData{x,4});
end
%coreDescLogDepth = cell2mat(coreDescLogDepth);
faciesPropResults = NMR_FaciesProportionTests( coreDescLogDepth, NMRData, 1.0 );
%Plot NMR FFV vs various image resisitivity cutoffs (all together & broken
%out for sandy/silty intervals vs siliceous shaley intervals)
%%TODO:Make a sep. function, feed it NMR + Resisitivity Pad + Cutoffs to
%%test
imagePadFile = uigetfile('*.txt', 'Select Image Log Pad Input File');
ResPadData = simpleTabImport(imagePadFile);
for x = 2:size(ResPadData, 1)
    ImageData(x-1,1) = str2double(ResPadData{x,1});
    ImageData(x-1,2) = str2double(ResPadData{x,2});
end
count = 0;
for x = 10:10:200
    count = count + 1;
CutoffsToTest(count,1) = x;
end
resultsArray = NMR_ImagePadComp( NMRData, ImageData, CutoffsToTest );
save('NMRResultsArrays.mat', 'faciesPropResults','resultsArray'); 

%%continued in NMR analysis pt2