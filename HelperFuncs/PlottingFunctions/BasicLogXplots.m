function  BasicLogXplots( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%neutron/density plot
    hold all;
    for x = 1:numberOfFaciesCodes
        if x == 1
            createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3), x - 1);
        else
            if x ~= excludeNumber
                plot(faciesDataArray(x,1).logData(:,5),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
            end
            %axes1 = gca;
            %legend1 = legend(axes1,'show');
            %set(legend1,'FontSize',9);
        end
       % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
    end
    legend(faciesCodeCell);
    figurename = strcat(folderName, '\', wellName, 'NeutronDensityXplot_AllFacies');
    %savefig(figurename);
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    
    hold off;
    for x = 1:numberOfFaciesCodes
        createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3), x - 1);
        figurename = strcat(folderName, '\', wellName, 'NeutronDensityXplot_faciesCode_', int2str(x - 1));
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
    end
    
%PEF density plot
hold all;
for x = 1:numberOfFaciesCodes
    if x == 1
        createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
        % plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3), x - 1);
    else
        if x ~= excludeNumber
            plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
        end
        %axes1 = gca;
        %legend1 = legend(axes1,'show');
        %set(legend1,'FontSize',9);
    end
    % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
end
legend(faciesCodeCell);
figurename = strcat(folderName, '\', wellName, '_PE_DensityXplot_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
    figurename = strcat(folderName, '\', wellName, '_PE_DensityXplot_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
end
%potassium/thorium xplot
hold all;
for x = 1:numberOfFaciesCodes
    if x == 1
        createTh_K_Xplot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,12));
        %plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,12),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
        % plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3), x - 1);
    else
        if x ~= excludeNumber
            plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,12),'DisplayName',char(x),'Marker','+','LineStyle','none');
        end
        %axes1 = gca;
        %legend1 = legend(axes1,'show');
        %set(legend1,'FontSize',9);
    end
    % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
end
legend(faciesCodeCell);
figurename = strcat(folderName, '\', wellName, '_Potassium_Th_Xplot_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
    faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,12);
    %plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,12),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, '_Potassium_Th_Xplot_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
end
%pota/PE xplot
hold all;
for x = 1:numberOfFaciesCodes
    if x == 1
        makePE_PotaXPLOT(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6));
        %plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
        % plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3), x - 1);
    else
        if x ~= excludeNumber
            plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
        end
        %axes1 = gca;
        %legend1 = legend(axes1,'show');
        %set(legend1,'FontSize',9);
    end
    % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
end
legend(faciesCodeCell);
figurename = strcat(folderName, '\', wellName, '_Potassium_PE_Xplot_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
    %plot(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    makePE_PotaXPLOT(faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6));
    figurename = strcat(folderName, '\', wellName, '_Potassium_PE_Xplot_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
end
%pe and thor/pota ratio xplot
% hold all;
% for x = 1:numberOfFaciesCodes
%     if x == 1
%         pota_thor = faciesDataArray(x,1).logData(:,12)./faciesDataArray(x,1).logData(:,11);
%         createPE_TH_K_Xplot(pota_thor, faciesDataArray(x,1).logData(:,6));
%         %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
%         %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
%         % plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
%         %createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3), x - 1);
%     else
%         if x ~= excludeNumber
%             pota_thor = faciesDataArray(x,1).logData(:,12)./faciesDataArray(x,1).logData(:,11);
%             plot(pota_thor,faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
%         end
%         %axes1 = gca;
%         %legend1 = legend(axes1,'show');
%         %set(legend1,'FontSize',9);
%     end
%     % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
% end
% legend(faciesCodeCell);
% figurename = strcat(folderName, '\', wellName, '_Potassium_Th_PE_Xplot_AllFacies');
% saveas(gcf, figurename, 'fig');
% saveas(gcf, figurename, 'jpg');
% close(gcf);
% hold off;
% for x = 1:numberOfFaciesCodes
%     %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
%     pota_thor = faciesDataArray(x,1).logData(:,12)./faciesDataArray(x,1).logData(:,11);
%     createPE_TH_K_Xplot(pota_thor, faciesDataArray(x,1).logData(:,6));
%     %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
%     figurename = strcat(folderName, '\', wellName, '_Potassium_Th_PE_Xplot_faciesCode_', int2str(x - 1));
%     saveas(gcf, figurename, 'fig');
%     saveas(gcf, figurename, 'jpg');
%     close(gcf);
% end

%pickett plot
hold all;
for x = 1:numberOfFaciesCodes
    if x == 1
        density_por = (faciesDataArray(x,1).logData(:,3) - 2.65)/-1.65;
        porosity = sqrt((density_por.^2 + faciesDataArray(x,1).logData(:,5).^2)/2);
        createPickettPlot(faciesDataArray(x,1).logData(:,7),porosity);
        %plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
        % plot(faciesDataArray(x,1).logData(:,6),faciesDataArray(x,1).logData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
        %createNeutronDensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3), x - 1);
    else
        if x ~= excludeNumber
            density_por = (faciesDataArray(x,1).logData(:,3) - 2.65)/-1.65;
        porosity = sqrt((density_por.^2 + faciesDataArray(x,1).logData(:,5).^2)/2);
        
        plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
        end
        %axes1 = gca;
        %legend1 = legend(axes1,'show');
        %set(legend1,'FontSize',9);
    end
    % plot(faciesDataArray(x,1).logData(:,5), faciesDataArray(x,1).logData(:,3));
end
legend(faciesCodeCell);
figurename = strcat(folderName, '\', wellName, 'PickettPlot_AllFacies');
saveas(gcf, figurename, 'fig');
saveas(gcf, figurename, 'jpg');
close(gcf);
hold off;
for x = 1:numberOfFaciesCodes
    %createPE_DensityXPLOT(faciesDataArray(x,1).logData(:,6), faciesDataArray(x,1).logData(:,3));
            density_por = (faciesDataArray(x,1).logData(:,3) - 2.65)/-1.65;
            porosity = sqrt((density_por.^2 + faciesDataArray(x,1).logData(:,5).^2)/2);
            createPickettPlot(faciesDataArray(x,1).logData(:,7),porosity);
           % plot(faciesDataArray(x,1).logData(:,7),porosity,'DisplayName',char(x),'Marker','+','LineStyle','none');
    %plot(faciesDataArray(x,1).logData(:,12)/faciesDataArray(x,1).logData(:,11),faciesDataArray(x,1).logData(:,6),'DisplayName',char(x),'Marker','+','LineStyle','none');
    figurename = strcat(folderName, '\', wellName, 'PicketPlot_faciesCode_', int2str(x - 1));
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
end

%%
end

