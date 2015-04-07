function [ faciesDataArray, numberOfFaciesCodes,MD_Core,Facies_CoreDepth] = dataPrep( )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
plugFile = uigetfile('*.txt', 'Select Core Plug File');
%[~,~,~,SAMPLE_ID,DEPTH_CORE,CKHA,~,~,CPOR,SOC,SWC,CDEN,~,CPOR_HUM,SOC_HUM,SWC_HUM,CDEN_HUM,~,~,~,~,~,~,~,~] = conventionalPlugDataImport(plugFile);
plugdata = simpleTabImport(plugFile);
for x = 1:size(plugdata,2)
    if strcmpi(plugdata,'CKHA')
        SWC = plugdata(4:size(plugdata,1),x);
        SWC = str2double(SWC);
    elseif strcmpi(plugdata,'DEPTH_CORE')
        DEPTH_CORE = plugdata(4:size(plugdata,1),x);
        DEPTH_CORE = str2double(DEPTH_CORE);
    elseif strcmpi(plugdata,'SOC') 
        SOC = plugdata(4:size(plugdata,1),x);
        SOC = str2double(SOC);
    elseif strcmpi(plugdata,'CDEN') 
        CDEN = plugdata(4:size(plugdata,1),x);
        CDEN = str2double(CDEN);
    elseif strcmpi(plugdata,'CPOR') 
        CPOR = plugdata(4:size(plugdata,1),x);
        CPOR = str2double(CPOR);
    elseif strcmpi(plugdata,'SWC')
        SWC = plugdata(4:size(plugdata,1),x);
        SWC = str2double(SWC);
    end
end
coreDescriptionFile = uigetfile('*.txt', 'Select Core Description File');
[MD_Shifted,Facies_LogDepth,MD_Core,Facies_CoreDepth] = coreDescriptionImport(coreDescriptionFile);
logFile = uigetfile('*.txt', 'Select Standard Log Inputs File');
[MD_Log,Gamma,RHOB,SP,XNPHIS,PEF,RD,RS,GammaNOUr,GammaK,GammaTh,GammaU,XMINV,XMNOR] = importStandardLogsv2(logFile);
numberOfFaciesCodes = max(Facies_CoreDepth) + 1;
faciesDataArray = faciesData.empty(numberOfFaciesCodes,0);
excludeNumber = 6;
count = 0;
for x = 1:numberOfFaciesCodes
    faciesDataArray(x,1) = faciesData();
    faciesDataArray(x,1).faciesCode = x - 1;
    if x ~= excludeNumber
        count = count + 1;
        %faciesCodeCell{count,1} = int2str(x - 1);
    end
end

descriptionMax = max(MD_Shifted);
descriptionMin = min(MD_Shifted);
for x = 1:length(MD_Log)
    if(MD_Log(x,1) < descriptionMin) | (MD_Log(x,1) > descriptionMax)
        continue;
    else
        %%find the facies code for the log point
        faciesCode = nan;
        for y = 2:1:length(Facies_LogDepth)
            currentDepth = MD_Log(x,1);
            testDepth = MD_Shifted(y,1);
            testDepthMinus1 = MD_Shifted(y-1,1);
            if (MD_Log(x,1) <= MD_Shifted(y,1)) 
                if y ~= 1
                    faciesCode = Facies_LogDepth(y-1,1);
                else
                    faciesCode = Facies_LogDepth(y,1);
                end
                break;
            end
        end
        if isnan(faciesCode)
            continue;
        end
        %%use the facies code to assign log points to the right data object
        %check the status of the data currently
        if faciesDataArray(faciesCode + 1,1).logData(1,1) == 0
           % [a,b] = size(faciesDataArray(faciesCode,1).logData());
            faciesDataArray(faciesCode + 1,1).logData(1, 1) = MD_Log(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 2) = Gamma(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 3) = RHOB(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 4) = SP(x,1);
            if iscell(XNPHIS)
                 faciesDataArray(faciesCode + 1,1).logData( 1, 5) = str2double(XNPHIS{x,1});
            else
                faciesDataArray(faciesCode + 1,1).logData( 1, 5) = XNPHIS(x,1);
            end
            faciesDataArray(faciesCode + 1,1).logData(1, 6) = PEF(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 7) = RD(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 8) = RS(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 9) = XMINV(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 10) = XMNOR(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 11) = GammaK(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 12) = GammaTh(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 13) = GammaU(x,1);
            faciesDataArray(faciesCode + 1,1).logData(1, 14) = GammaNOUr(x,1);
        else
            [a,b] = size(faciesDataArray(faciesCode + 1,1).logData);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 1) = MD_Log(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 2) = Gamma(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 3) = RHOB(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 4) = SP(x,1);
            if iscell(XNPHIS)
                 faciesDataArray(faciesCode + 1,1).logData(a + 1, 5) =  str2double(XNPHIS{x,1});
            else
                faciesDataArray(faciesCode + 1,1).logData(a + 1, 5) = XNPHIS(x,1);
            end
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 6) = PEF(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 7) = RD(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 8) = RS(x,1);
             faciesDataArray(faciesCode + 1,1).logData(a + 1, 9) = XMINV(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 10) = XMNOR(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 11) = GammaK(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 12) = GammaTh(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 13) = GammaU(x,1);
            faciesDataArray(faciesCode + 1,1).logData(a + 1, 14) = GammaNOUr(x,1);
            
        end
    end
end
clear currentDepth descriptionMax descriptionMin testDepth testDepthMinus x y faciesCode a b
%%Get facies plug data breakout
for x = 1:length(DEPTH_CORE)
    %%find facies code for plug
    faciesCode = nan;
        for y = 2:1:length(Facies_CoreDepth)
            currentDepth = DEPTH_CORE(x,1);
            %testDepth = MD_Shifted(y,1);
            %testDepthMinus1 = MD_Shifted(y-1,1);
            if (DEPTH_CORE(x,1) <= MD_Core(y,1)) 
                if y ~= 1
                    faciesCode = Facies_CoreDepth(y-1,1);
                else
                    faciesCode = Facies_CoreDepth(y,1);
                end
                break;
            end
        end
        if isnan(faciesCode)
            continue;
        end
        %disp(faciesCode);
        %%use the facies code to assign log points to the right data object
        %check the status of the data currently
        if faciesDataArray(faciesCode + 1,1).plugData(1,1) == 0
            
            faciesDataArray(faciesCode + 1,1).plugData(1, 1) = DEPTH_CORE(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(1, 2) = CPOR(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(1, 3) = CKHA(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(1, 4) = CDEN(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(1, 5) = SOC(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(1, 6) = SWC(x,1);
            
        else
            [a,~] = size(faciesDataArray(faciesCode + 1,1).plugData);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 1) = DEPTH_CORE(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 2) = CPOR(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 3) = CKHA(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 4) = CDEN(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 5) = SOC(x,1);
            faciesDataArray(faciesCode + 1,1).plugData(a + 1, 6) = SWC(x,1);
        end
end
clear currentDepth descriptionMax descriptionMin testDepth testDepthMinus x y faciesCode a b

%%Make shifted core plug vars
coreShifts(1,1) = coreShift(8565.0,8568.0, 6.428);
coreShifts(2,1) = coreShift(8584.0,8585.8, 6.428);
coreShifts(3,1) = coreShift(8588.3,8608, 7.2);
coreShifts(4,1) = coreShift(8608.0,8611.0, 7.2);
coreShifts(5,1) = coreShift(8613.0,8643.0, 7.2);
coreShifts(6,1) = coreShift(8643.0,8671.4, 7.2);
coreShifts(7,1) = coreShift(8673.0,8699.1, 5.6);
coreShifts(8,1) = coreShift(8980,8980.2, 7.77);
coreShifts(9,1) = coreShift(8981.0,9010.2, 7.77);
coreShifts(10,1) = coreShift(9011.0,9039.9, 7.77);
coreShifts(11,1) = coreShift(9041.0,9071, 7.77);
coreShifts(12,1) = coreShift(9071.0,9101.8, 7.77);

for x = 1:length(faciesDataArray)
    [a,~] = size(faciesDataArray(x,1).plugData);
    for y = 1:a
        %%Shift the core plug data's depth to log depth
        found = false;
        for z = 1:length(coreShifts)
            
            
            if faciesDataArray(x,1).plugData(y,1) >= coreShifts(z,1).topMD
                if faciesDataArray(x,1).plugData(y,1) <= coreShifts(z,1).bottomMD
                    
                    faciesDataArray(x,1).shiftedLog_PlugData(y,1) = faciesDataArray(x,1).plugData(y,1) + coreShifts(z,1).Shift;
                    found = true;
                    break;
                    
                end
            end
        end
        if ~found
            disp('Problem with core plug shift!');
        end
        faciesDataArray(x,1).shiftedLog_PlugData(y,2) = faciesDataArray(x,1).plugData(y,2);
        faciesDataArray(x,1).shiftedLog_PlugData(y,3) = faciesDataArray(x,1).plugData(y,3);
        faciesDataArray(x,1).shiftedLog_PlugData(y,4) = faciesDataArray(x,1).plugData(y,4);
        faciesDataArray(x,1).shiftedLog_PlugData(y,5) = faciesDataArray(x,1).plugData(y,5);
        faciesDataArray(x,1).shiftedLog_PlugData(y,6) = faciesDataArray(x,1).plugData(y,6);
        %%find the log data associated with the core plug
        for z = 1:length(MD_Log)
            if found
                if faciesDataArray(x,1).shiftedLog_PlugData(y,1) <= MD_Log(z,1)
                    faciesDataArray(x,1).shiftedLog_PlugData(y,7) = Gamma(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,8) = RHOB(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,9) = PEF(z,1);
                    if iscell(XNPHIS)
                        faciesDataArray(x,1).shiftedLog_PlugData(y,10) = str2double(XNPHIS{z,1});
                    else
                        faciesDataArray(x,1).shiftedLog_PlugData(y,10) = XNPHIS(z,1);
                    end
                    faciesDataArray(x,1).shiftedLog_PlugData(y,11) = RD(z,1); 
                    faciesDataArray(x,1).shiftedLog_PlugData(y,12) = RS(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,13) = XMINV(z,1); 
                    faciesDataArray(x,1).shiftedLog_PlugData(y,14) = XMNOR(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,15) = GammaK(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,16) = GammaTh(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,17) = GammaU(z,1);
                    faciesDataArray(x,1).shiftedLog_PlugData(y,18) = GammaNOUr(z,1);
                    break;
                end
            end
        end
    end
end

%%Add luminosity info to array(s)
    %load luminosity
    luminosityVariableFile = uigetfile('*.mat', 'Select Luminosity Var Inputs File');
    load(luminosityVariableFile);
    %Convert from core to log depth
    found = false;
    for x = 1:length(AvgLuminosity)
        for z = 1:length(coreShifts)
            
            
            if AvgLuminosity(x,1) >= coreShifts(z,1).topMD
                if AvgLuminosity(x,1) <= coreShifts(z,1).bottomMD
                    
                    AvgLuminosity(x,3) = AvgLuminosity(x,1) + coreShifts(z,1).Shift;
                    found = true;
                    break;
                    
                end
            end
        end
        if ~found
            disp('Problem with luminosity shift!');
        end
    end
    for x = 1:length(faciesDataArray)
        %populate each array with averaged luminosity data
        %LOG Data
        [a,b] = size(faciesDataArray(x,1).logData);
        for y = 1:a
            %%Populate Log Array with Luminosity
                %function to extract luminosity over an area of
                %investigation
            faciesDataArray(x,1).logData(y, b + 1) = avgLuminosityAtDepthForHeight( AvgLuminosity, faciesDataArray(x,1).logData(y, 1), 0.33 );
        end
        [a,b] = size(faciesDataArray(x,1).shiftedLog_PlugData);
        
        for y = 1:a
            faciesDataArray(x,1).shiftedLog_PlugData(y, b + 1) = avgLuminosityAtDepthForHeight( AvgLuminosity, faciesDataArray(x,1).shiftedLog_PlugData(y, 1), 0.042 );
        end
    end
end

