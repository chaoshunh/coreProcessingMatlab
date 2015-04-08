function [ results  ] = NMR_ImagePadComp( NMR, ImageData, CutoffsToTest )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
toolRes = 1;
results = zeros(1,size(CutoffsToTest,1) + 2);
count = 0;
found = false;
%%Loop through NMR dataset, pull image resistivity data for the NMR tool
%%resolution
defaultImageStepSize = ImageData(2,1) - ImageData(1,1);
h = waitbar(1/size(NMR,1), 'Matching Image and NMR data');
for x = 1:size(NMR,1)
    imageResPoints = zeros(1,3);
    count2 = 0;
    for y = 2:size(ImageData)
        
        if (ImageData(y,1) > (NMR(x,1) - toolRes)) && (ImageData(y,1) < (NMR(x,1) + toolRes))
            count2 = count2 + 1;
            found = true;
            imageResPoints(count2,1) = ImageData(y,1);
            imageResPoints(count2,2) = ImageData(y,2);
        end
    end
if found
    for y = 1:size(imageResPoints,1)
        if size(imageResPoints,1) > 100
          imageResPoints(y,3) =( (toolRes + toolRes)/ size(imageResPoints,1))/(toolRes + toolRes);
        else
          continue;  
        end
    end
%%Loop through the cuttoffs and determine the pct of the NMR measurement
%%that meets each cutoff

count = count + 1;
results(count,1) = NMR(x,1);
results(count,2) = NMR(x,2);
for y = 1:size(CutoffsToTest, 1)
    flag = imageResPoints(:,2) >= CutoffsToTest(y,1);
    results(count,y+2) = sum(imageResPoints(flag,3));
end
%%plot NMR FFV vs the Pct for each cutoff

end
waitbar(x/size(NMR,1),h,'Matching Image and NMR data');
end
close(h);
for x = 3:size(CutoffsToTest)
    titleStr = strcat('NMR vs %of Image Log Above cutoff ', mat2str((x - 2) * 10));
    figure1 = figure;
    
    % Create axes
    axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on');
    
    xlim(axes1,[0 0.2]);
    ylim(axes1,[0 1]);
    hold(axes1,'on');
    
    % Create ylabel
    ylabel({'% of Image Points above Cutoff'});
    
    % Create xlabel
    xlabel({'Free Fluid Volume (NMR)'});
    
    % Create title
    
    title(titleStr);
    scatter(results(:,2), results(:,x));
    
    figname = strcat('NMR_imageLog_abovecutoff_', mat2str((x - 2) * 10), '.fig');
    saveas(gcf, figname);
    hold(axes1,'off');
    close(gcf);
end

end

