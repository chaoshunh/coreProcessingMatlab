function basicLogHistograms( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,2), 50);
            end
    end
    legend(faciesCodeCell);
    figurename = strcat(folderName, '\', wellName, '_GR_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,2), 50);
        figurename = strcat(folderName, '\', wellName, '_GR_Histogram_faciesCode_', int2str(x - 1));
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
    %facies PEF histogram(s)
    hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,6), 50);
            end
    end
    legend(faciesCodeCell);
    figurename = strcat(folderName, '\', wellName, '_PEF_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,6), 50);
        figurename = strcat(folderName, '\', wellName, '_PEF_Histogram_faciesCode_', int2str(x - 1));
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
%facies GR w/o uranium histogram(s)
    hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,14), 50);
            end
    end
    
    legend(faciesCodeCell);
    title('GR (no U) Histogram by Facies');
    figurename = strcat(folderName, '\', wellName, '_GR_NO_U_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,14), 50);
        titleStr = strcat('GR (no U) Histogram for facies code: ', int2str(x - 1));
        title(titleStr);
        %title('GR (no U) Histogram for ');
        figurename = strcat(folderName, '\', wellName, '_GR_NO_U_Histogram_faciesCode_', int2str(x - 1));
        
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
 %facies uranium histogram(s)
    hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,13), 50);
            end
    end
    
    legend(faciesCodeCell);
    title('Uranium Histogram by Facies');
    figurename = strcat(folderName, '\', wellName, 'U_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,13), 50);
        titleStr = strcat('Uranium Histogram for facies code: ', int2str(x - 1));
        title(titleStr);
        %title('GR (no U) Histogram for ');
        figurename = strcat(folderName, '\', wellName, 'U_Histogram_faciesCode_', int2str(x - 1));
        
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
    
     %facies thorium histogram(s)
    hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,12), 50);
            end
    end
    
    legend(faciesCodeCell);
    title('Thorium Histogram by Facies');
    figurename = strcat(folderName, '\', wellName, 'Th_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,12), 50);
        titleStr = strcat('Thorium Histogram for facies code: ', int2str(x - 1));
        title(titleStr);
        %title('GR (no U) Histogram for ');
        figurename = strcat(folderName, '\', wellName, 'Th_Histogram_faciesCode_', int2str(x - 1));
        
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
     %facies potassium histogram(s)
    hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).logData(:,11), 50);
            end
    end
    
    legend(faciesCodeCell);
    title('Potassium Histogram by Facies');
    figurename = strcat(folderName, '\', wellName, 'Pota_Histogram_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).logData(:,11), 50);
        titleStr = strcat('Postassium Histogram for facies code: ', int2str(x - 1));
        title(titleStr);
        %title('GR (no U) Histogram for ');
        figurename = strcat(folderName, '\', wellName, 'Pota_Histogram_faciesCode_', int2str(x - 1));
        
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
end

