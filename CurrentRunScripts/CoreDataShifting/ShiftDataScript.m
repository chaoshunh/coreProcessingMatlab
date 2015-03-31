clear all;
filename = 'CoreOilStain2.txt';

[MD,Facies] = importPetrelTabDelimSS(filename);
%%363X-16R Core Shifts
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
%MD2 = MD;

for x = 1:length(MD)
    found = false;
    for y = 1:length(coreShifts)
        if MD(x,1) >= coreShifts(y,1).topMD
            if MD(x,1) <= coreShifts(y,1).bottomMD
                if  ~isnan(Facies(x,1))
                MD(x,1) = MD(x,1) + coreShifts(y,1).Shift;
                found = true;
                    break;
                else
                    MD(x,1) = MD(x,1) + coreShifts(y,1).Shift;
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

fid = fopen('shiftedLog.txt', 'w');
for x = 1:length(MD)
    if ~isnan(MD(x,1))
        fprintf(fid,'%.4f %0.f\n', MD(x,1), Facies(x,1));
    end
end

fclose(fid);