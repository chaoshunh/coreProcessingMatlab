clear all;

%%Select Name of File with Data to shift
filename =  uigetfile('*.txt', 'Select file with data to shift');

%Select iPoint Shifts File
try
shiftsFile = uigetfile('*.csv', 'Select ipoint Core Shifts Info .csv');
shifts = simpleCSVImport(shiftsFile);
[a,~] = size(shifts);
shifts = shifts(5:a,:);
shifts = str2double(shifts);
clear a;
catch err
    warndlg('Warning! shifts file not loaded, unrecognized format.');
    
end


[MD,Facies] = importPetrelTabDelimSS(filename);
%%363X-16R Core Shifts
for x = 1:size(shifts,1)
    if x ~= size(shifts,1)
        if MD(1,1) <= shifts(1,1)
            coreShifts(x,1) = coreShift(MD(1,1),shifts(x+1,1), shifts(x,2));
        else
            coreShifts(x,1) = coreShift(shifts(x,1),shifts(x+1,1), shifts(x,2));
        end
    else
        coreShifts(x,1) = coreShift(shifts(x,1),MD(size(MD,1),1), shifts(x,2));
    end
end
% coreShifts(2,1) = coreShift(8584.0,8585.8, 6.428);
% coreShifts(3,1) = coreShift(8588.3,8608, 7.2);
% coreShifts(4,1) = coreShift(8608.0,8611.0, 7.2);
% coreShifts(5,1) = coreShift(8613.0,8643.0, 7.2);
% coreShifts(6,1) = coreShift(8643.0,8671.4, 7.2);
% coreShifts(7,1) = coreShift(8673.0,8699.1, 5.6);
% coreShifts(8,1) = coreShift(8980,8980.2, 7.77);
% coreShifts(9,1) = coreShift(8981.0,9010.2, 7.77);
% coreShifts(10,1) = coreShift(9011.0,9039.9, 7.77);
% coreShifts(11,1) = coreShift(9041.0,9071, 7.77);
% coreShifts(12,1) = coreShift(9071.0,9101.8, 7.77);
%MD2 = MD;

for x = 1:length(MD)
    found = false;
    for y = 1:length(coreShifts)
        if MD(x,1) >= coreShifts(y,1).topMD
            if MD(x,1) <= coreShifts(y,1).bottomMD
                if  ~isnan(Facies(x,1))
                MD(x,1) = MD(x,1) + coreShifts(y,1).Shift;
                if (x ~=1) && (MD(x,1) <= MD(x-1,1))
                    MD(x,1) = MD(x-1,1) + .01;
                end
                found = true;
                    break;
                else
                    MD(x,1) = MD(x,1) + coreShifts(y,1).Shift;
                    if (x ~=1) && (MD(x,1) <= MD(x-1,1))
                        MD(x,1) = MD(x-1,1) + .01;
                    end
                    Facies(x,1) = 9;
                    found = true;
                    break;
                    
                end
            end
        end
        
    end
    if ~found
       MD(x,1) = nan;
       Facies(x,1) = nan; 
    end
end
outputFile = strcat('shifted', filename);
fid = fopen(outputFile, 'w');
for x = 1:length(MD)
    if ~isnan(MD(x,1))
        fprintf(fid,'%.6f %0.f\n', MD(x,1), Facies(x,1));
    end
end

fclose(fid);