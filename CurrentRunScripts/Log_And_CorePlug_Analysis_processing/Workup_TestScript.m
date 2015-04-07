%%Core Data Workup

%%INPUTS NEEDED:

%%Resistivity logs
%Porosity(Density/Neutron/Sonic)
%PEF
%GR (Total & spectral)
%Lithofacies description
%Porsity, Perm, Matrix density, saturation from plugs (maybe MICP data
%too??)
%oil stain observations
%PS14 facies
%NWS facies


%%BEGIN PROGRAM
clear all;

%%SET folder and wellname
wellName = inputdlg('Enter Well Name','WellName');
folderName = 'outputs';
mkdir(folderName);



% %%Break down data into lithofacies, bundled function that preps the data
% for convienent plotting
[ faciesDataArray, numberOfFaciesCodes, MD_Core,Facies_CoreDepth ] = dataPrep( );

%Facies code cell populates the legend for plots
faciesCodeCell = cell(numberOfFaciesCodes - 1,1);
faciesCodeCell{1,1} = 'Porc Shale';
faciesCodeCell{2,1} = 'Porc Chert';
faciesCodeCell{3,1} = 'Sandstone';
faciesCodeCell{4,1} = 'Silt';
faciesCodeCell{5,1} = 'Shale/Ms';
faciesCodeCell{6,1} = 'Ash';
%%This is a facies code that should be excluded (e.g. no core recovery
%%code)
excludeNumber = 6;

count = 0;
for x = 1:numberOfFaciesCodes
   
    if x ~= excludeNumber
        count = count + 1;
        
    end
end



%%Make basic log output charts (colored by facies plots)

BasicLogXplots( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes )
            
basicLogHistograms( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes  );
    

    %(need sat description), show pickett plot and litho-density plot with log flouresensce colored
    
    %(separate plot for each facies)

    
 %%Make basic plug data histograms (colored by facies)
    %por/perm
    hold on;
     for x = 1:numberOfFaciesCodes
        if x == 1
            %plot(faciesDataArray(x,1).plugData(:,2),faciesDataArray(x,1).plugData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
            corePlugPorosityPermXPLOT(faciesDataArray(x,1).plugData(:,2), faciesDataArray(x,1).plugData(:,3));
        else
           if x ~= excludeNumber
            plot(faciesDataArray(x,1).plugData(:,2),faciesDataArray(x,1).plugData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
           end
        end
     end
    legend(faciesCodeCell);
    figurename = strcat(folderName, '\', wellName, '_Plug_PorPermXplot_AllFacies');
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    hold off;
    
    for x = 1:numberOfFaciesCodes
        
            %plot(faciesDataArray(x,1).plugData(:,2),faciesDataArray(x,1).plugData(:,3),'DisplayName',char(x),'Marker','+','LineStyle','none');
            corePlugPorosityPermXPLOT(faciesDataArray(x,1).plugData(:,2), faciesDataArray(x,1).plugData(:,3));
            figurename = strcat(folderName, '\', wellName, '_Plug_PorPermXplot_faciesCode_', int2str(x - 1));
            saveas(gcf, figurename, 'fig');
            saveas(gcf, figurename, 'jpg');
            close(gcf);
     end
    %matrix density histogram
 hold all;
    for x = 1:numberOfFaciesCodes
            if x ~= excludeNumber
                histogram(faciesDataArray(x,1).plugData(:,4), 25);
            end
    end
    legend(faciesCodeCell);
    figurename = strcat(folderName, '\', wellName, '_Plug_Density_All_');
    hold off;
    saveas(gcf, figurename, 'fig');
    saveas(gcf, figurename, 'jpg');
    close(gcf);
    for x = 1:numberOfFaciesCodes
            
        histogram(faciesDataArray(x,1).plugData(:,4), 25);
        figurename = strcat(folderName, '\', wellName, '_Plug_Density_faciesCode_', int2str(x - 1));
        saveas(gcf, figurename, 'fig');
        saveas(gcf, figurename, 'jpg');
        close(gcf);
            
    end
%%Make combination plug/log plots    
    %apply log shift to plug data
    %PEF/Density plots for each facies colored by plug perm data
    %Log porosity vs plug porosity x-plot
PlugAndLogXPlots( faciesDataArray, folderName, wellName, excludeNumber, faciesCodeCell, numberOfFaciesCodes ) ;  
%%Make summary tables
netFacies = zeros(6,1);
    %Show total net ft of facies
    for x = 1:(length(MD_Core)-1)
        sizeOfBed = MD_Core(x+1,1) - MD_Core(x,1);
        if Facies_CoreDepth(x,1) == excludeNumber
            continue;
        elseif isnan(Facies_CoreDepth(x,1))
            continue;
        elseif Facies_CoreDepth(x,1) > excludeNumber
            netFacies(Facies_CoreDepth(x,1),1) = netFacies(Facies_CoreDepth(x,1),1) + sizeOfBed;
        else
            netFacies(Facies_CoreDepth(x,1) + 1,1) = netFacies(Facies_CoreDepth(x,1) + 1,1) + sizeOfBed;
        end
    end
    %Net ft of facies by current models
    %Differences between model/core description
    %Pct of each facies with visible oil flour.
    %Total net ft of oil saturated rock
    
%%OUTPUTS ideas:

%%Facies vs matrix density
%Porosity/Perm chart with facies colored in
%neutron density plot (colored for facies)
%PEF/Density with facies colored in
%PEF/Density/Perm 3D plot of just sand (separate one for porc shale/chert)
%Spectral Gamma- PE vs Th/K ratio (clay typing)
%Spectral Gamma
%Pickett Plot, colored by facies
%Pickett plot isolated to one facies, but showing whether saturated or not
%matrix density vs spectral gamma plot (using plugs)
%facies total gamma histograms
%1D Net facies volume tables
% percent of each facies that is saturated (i.e. net pay)
%net facies in core vs PS14 and current NWS models
%perm vs near/far detector difference in shallow resistivity
%PEF, Log Porosity Histograms


