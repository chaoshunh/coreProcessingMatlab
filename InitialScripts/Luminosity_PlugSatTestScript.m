%%%Comparison of Luminosity and Plug Sat
%%Requires luminosity from the CorePhotoProcessingTestScript%%%%%%%%%%
%[~,~,~,SAMPLE_ID,DEPTH_CORE,CKHA,~,~,CPOR,SOC,SWC,CDEN,~,CPOR_HUM,SOC_HUM,SWC_HUM,CDEN_HUM,~,~,~,~,~,~,~,~] = conventionalPlugDataImport('322X-24RCorePlugInputs.txt');
%CorePlugInputs = importCorePlugs('322X-24RCorePlugInputs.txt');
[ CorePlugInputs ] = simpleTabImport( '322X-24RCorePlugInputs.txt');
[a,b] = size(CorePlugInputs);
for x = 1:b
    if strcmp(CorePlugInputs{1,x}, 'DEPTH_CORE')
        DEPTH_CORE = CorePlugInputs(4:a,x);
        DEPTH_CORE = str2double(DEPTH_CORE);
    elseif strcmp(CorePlugInputs{1,x}, 'SOC')
         SOC = CorePlugInputs(4:a,x);
         SOC = str2double(SOC);
    elseif strcmp(CorePlugInputs{1,x}, 'LITH')
        LITH = CorePlugInputs(4:a,x);
    end
end
for x = 1:length(SOC)
    [ SOC(x,2)] = avgLuminosityAtDepthForHeight( AvgLuminosity, DEPTH_CORE(x,1), ((1/12)/2) );
    [ SOC(x,4) ] = avgPeakLuminosityAtDepthForHeight(  AvgLuminosity, DEPTH_CORE(x,1), ((1/12)/2) );
    if strncmpi(LITH{x,1}, 'mdst',4)
        SOC(x,5) = 0;
    elseif strncmpi(LITH{x,1}, 'sst',3)
        SOC(x,5) = 1;
    elseif strncmpi(LITH{x,1}, 'slt',3)
        SOC(x,5) = 2;
    elseif strncmpi(LITH{x,1}, 'dol',3)
        SOC(x,5) = 3;
    elseif strncmpi(LITH{x,1}, 'cht',3)
        SOC(x,5) = 4;
    end
end
SOC(:,3) = DEPTH_CORE;
%scatter3(SOC(:,2), SOC(:,1), SOC(:,3));

mudFilter = SOC(:,5) == 0;
sandFilter = SOC(:,5) == 1;
siltFilter = SOC(:,5) == 2;
dolFilter = SOC(:,5) == 3;
chertFilter = SOC(:,5) == 4;
figure
%scatter(SOC(mudFilter,4), SOC(mudFilter,1));
plugLuminosityXPLOT(SOC(mudFilter,4), SOC(mudFilter,1));
title('Mudstone Luminosity vs Plug Oil Saturation');
xlabel('Luminosity Index');
ylabel('Plug Oil Saturation %');
grid on;

savefig('Mudstn_Scatter');
saveas(gcf ,'Mudstn_Scatter.jpg');
close(gcf);
plugLuminosityXPLOT(SOC(sandFilter,4), SOC(sandFilter,1));
%scatter(SOC(sandFilter,4), SOC(sandFilter,1));
title('Sandstone Luminosity vs Plug Oil Saturation');
xlabel('Luminosity Index');
ylabel('Plug Oil Saturation %');
grid on;
savefig('Sandstn_Scatter');
saveas(gcf ,'Sandstn_Scatter.jpg');
close(gcf);
plugLuminosityXPLOT(SOC(siltFilter,4), SOC(siltFilter,1));
%scatter(SOC(siltFilter,4), SOC(siltFilter,1));
title('Siltstone Luminosity vs Plug Oil Saturation');
xlabel('Luminosity Index');
ylabel('Plug Oil Saturation %');
grid on;
savefig('Siltstn_Scatter');
saveas(gcf ,'Siltstn_Scatter.jpg');
close(gcf);
plugLuminosityXPLOT(SOC(dolFilter,4), SOC(dolFilter,1));
%scatter(SOC(dolFilter,4), SOC(dolFilter,1));
title('Dolomite Luminosity vs Plug Oil Saturation');
xlabel('Luminosity Index');
ylabel('Plug Oil Saturation %');
grid on;
savefig('Dolstn_Scatter');
saveas(gcf ,'Dolstn_Scatter.jpg');
close(gcf);
plugLuminosityXPLOT(SOC(chertFilter,4), SOC(chertFilter,1));
%scatter(SOC(chertFilter,4), SOC(chertFilter,1));
title('Chert Luminosity vs Plug Oil Saturation');
xlabel('Luminosity Index');
ylabel('Plug Oil Saturation %');
grid on;
savefig('chert_Scatter');
saveas(gcf ,'chert_Scatter.jpg');
close(gcf);