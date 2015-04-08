function [ results] = NMR_FaciesProportionTests( coreDescLogDepth, NMR, toolRes )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
results = zeros(1,9); %1-depth 2-NMR 3- %sand 4- %silt 5- % silicieous shale 6- % silty sand 7- %silt + sand 8-%cleaner silc shale 9-%clay rich sil shale
count = 0;
for x = 1:size(NMR,1)
    if (NMR(x,1) - toolRes) < coreDescLogDepth(1,1) || (NMR(x,1) + toolRes) > coreDescLogDepth(size(coreDescLogDepth,1),1)
     continue;
    end
    count = count + 1;
    faciesForStep = zeros(1,3);
    flag = false;
    count2 = 0;
    found = false;
    for y = 1:size(coreDescLogDepth)
        if coreDescLogDepth(y,1) > (NMR(x,1) - toolRes) && coreDescLogDepth(y,1) < (NMR(x,1) + toolRes)
            if count2 == 0
                flag = true;
                found = true;
                count2 = count2 + 1;
                if coreDescLogDepth(y,1) == (NMR(x,1) - toolRes)
                    faciesForStep(count2, 1) = coreDescLogDepth(y,1);
                else
                    faciesForStep(count2, 1) = NMR(x,1) - toolRes;
                end
                if y ~= 1
                    faciesForStep(count2, 2) = coreDescLogDepth(y-1,2);
                else
                    faciesForStep(count2, 2) = coreDescLogDepth(y,2);
                end
            end
                count2 = count2 + 1;
                faciesForStep(count2, 1) = coreDescLogDepth(y,1);
                faciesForStep(count2, 2) = coreDescLogDepth(y,2);
            
        else
            if flag
                count2 = count2 + 1;
                faciesForStep(count2, 2) = coreDescLogDepth(y,2);
                if coreDescLogDepth(y,1) == (NMR(x,1) + toolRes)
                    faciesForStep(count2, 1) = coreDescLogDepth(y,1);
                else
                    faciesForStep(count2, 1) = NMR(x,1) + toolRes;
                end
                break;
            end
        end
    end
    if ~found
        count = count - 1;
        continue;
    end
    results(count,1) = NMR(x,1);
    results(count,2) = NMR(x,2);
    for y = 1:(size(faciesForStep,1) - 1)
        divisor = toolRes + toolRes;
        faciesForStep(y,3) = (faciesForStep(y+1,1) - faciesForStep(y,1))/divisor;
        
    end
    sand = faciesForStep(:,2) == 3;
    silt = faciesForStep(:,2) == 4;
    siltyMS = faciesForStep(:,2) == 7;
    sandPlusSilt = (faciesForStep(:,2) == 3) | (faciesForStep(:,2) == 4);
    siliceousSh = (faciesForStep(:,2) == 1) | (faciesForStep(:,2) == 0);
    cleanerSilSh = (faciesForStep(:,2) == 0);
    clayrichSilSh = (faciesForStep(:,2) == 1);
    
    results(count,3) = sum(faciesForStep(sand,3));
    results(count,4) = sum(faciesForStep(silt,3));
    results(count,5) = sum(faciesForStep(siliceousSh,3));
    results(count,6) = sum(faciesForStep(siltyMS,3));
    results(count,7) = sum(faciesForStep(sandPlusSilt,3));
    results(count,8) = sum(faciesForStep(cleanerSilSh,3));
    results(count,9) = sum(faciesForStep(clayrichSilSh,3));
    
end
for x = 3:9
plotname = strcat('FFV_faciesProportion', mat2str(x)', '.fig');
scatter(results(:,2),results(:,x));
saveas(gcf, plotname);
close(gcf);
end
end

