function PlugAndLogXPlots( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here

%%use scatter plot with RGB matrix and can use marker area (for a 4D
%%display!)

%%Pickett Plot with Plug Oil Sat
faciesCount = 0;
faciesForLegend = cell(1,1);
for x = 1:numberOfFaciesCodes
    if x == 1
        saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
        faciesCount = 1;
        faciesForLegend{1,1} = faciesCodeCell{1,1};
       % scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
        createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
    else
        [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
            
            if x ~= excludeNumber
                if x > length(faciesCodeCell)
                    faciesCount = faciesCount + 1;
                    faciesForLegend{faciesCount,1} = faciesCodeCell{6,1}; 
                else
                faciesCount = faciesCount + 1;
                faciesForLegend{faciesCount,1} = faciesCodeCell{x,1};
                end
                saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
                
                scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
            end
        end
        
    end
    
end
legend(faciesForLegend);
figurename = strcat(folderName, '\', wellName, 'PickettPlot_PlugSat_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
            saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
        
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
        createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
           % plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
    %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, 'PicketPlot_PlugSat_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
        end
end
%%Pickett Plot with Matrix density
faciesCount = 0;
faciesForLegend = cell(1,1);
for x = 1:numberOfFaciesCodes
    if x == 1
        saturationSize = (((faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./ .30) .* 72) + 1;
        faciesCount = 1;
        faciesForLegend{1,1} = faciesCodeCell{1,1};
       % scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
        createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
    else
        [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
            
            if x ~= excludeNumber
                if x > length(faciesCodeCell)
                    faciesCount = faciesCount + 1;
                    faciesForLegend{faciesCount,1} = faciesCodeCell{6,1}; 
                else
                faciesCount = faciesCount + 1;
                faciesForLegend{faciesCount,1} = faciesCodeCell{x,1};
                end
                saturationSize = (( (faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./ .30) .* 72) + 1;
                
                scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
            end
        end
        
    end
    
end
legend(faciesForLegend);
figurename = strcat(folderName, '\', wellName, 'PickettPlot_MatrixDens_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
            saturationSize = (( (faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./ .30) .* 72) + 1;
        
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize);
        createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
           % plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
    %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, 'PicketPlot_MatrixDens_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
        end
end
%%PEF/Density log with perm
%%Pickett Plot with Matrix density
faciesCount = 0;
faciesForLegend = cell(1,1);
for x = 1:numberOfFaciesCodes
    if x == 1
        saturationSize = (( (faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./.30) .* 72) + 1;
        faciesCount = 1;
        faciesForLegend{1,1} = faciesCodeCell{1,1};
        create4DPEF_Density_XPLOT(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize, [0 0 0], 'PEF vs Density with Plug Matrix Density MarkerSizes');
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
        %createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
    else
        [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
            
            if x ~= excludeNumber
                if x > length(faciesCodeCell)
                    faciesCount = faciesCount + 1;
                    faciesForLegend{faciesCount,1} = faciesCodeCell{6,1}; 
                else
                faciesCount = faciesCount + 1;
                faciesForLegend{faciesCount,1} = faciesCodeCell{x,1};
                end
                saturationSize = (( (faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./.30) .* 72) + 1;
                
                scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
            end
        end
        
    end
    
end
legend(faciesForLegend);
figurename = strcat(folderName, '\', wellName, 'PEF_DENS_XPLOT_MatrixDens_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
            saturationSize = (((faciesDataArray(x,1).shiftedLog_PlugData(:,4) - 2.45) ./.30) .* 72) + 1;
        create4DPEF_Density_XPLOT(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize, [0 0 0], 'PEF vs Density with Plug Matrix Density MarkerSizes');
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
        %createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
           % plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
    %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, 'PEF_DENS_XPLOT_MatrixDens_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
        end
end
%%PEF/Density log with porosity

%%PEF/Density with Plug Oil Sat
faciesCount = 0;
faciesForLegend = cell(1,1);
for x = 1:numberOfFaciesCodes
    if x == 1
        saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
        faciesCount = 1;
        faciesForLegend{1,1} = faciesCodeCell{1,1};
        create4DPEF_Density_XPLOT(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize, [0 0 0], 'PEF vs Density with Plug Oil Saturation MarkerSizes');
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
        %createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
    else
        [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
            
            if x ~= excludeNumber
                if x > length(faciesCodeCell)
                    faciesCount = faciesCount + 1;
                    faciesForLegend{faciesCount,1} = faciesCodeCell{6,1}; 
                else
                faciesCount = faciesCount + 1;
                faciesForLegend{faciesCount,1} = faciesCodeCell{x,1};
                end
                saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
                
                scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
            end
        end
        
    end
    
end
legend(faciesForLegend);
figurename = strcat(folderName, '\', wellName, 'PEF_DENS_XPLOT_PlugSat_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    [a,~] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        if a > 1
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
            saturationSize = ((faciesDataArray(x,1).shiftedLog_PlugData(:,5)./30) .* 72) + 1;
        create4DPEF_Density_XPLOT(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize, [0 0 0], 'PEF vs Density with Plug Oil Saturation MarkerSizes');
        %scatter(faciesDataArray(x,1).shiftedLog_PlugData(:,9),faciesDataArray(x,1).shiftedLog_PlugData(:,8), saturationSize);
        %createSaturationPickettPlot(faciesDataArray(x,1).shiftedLog_PlugData(:,11),faciesDataArray(x,1).shiftedLog_PlugData(:,2), saturationSize, [0 0 0]);
           % plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
    %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, 'PEF_DENS_XPLOT_PlugSat_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
        end
end
%%Plug porosity vs log porosity x plot (with matrix density)

end

