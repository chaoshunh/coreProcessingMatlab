classdef imageClassification
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = ''
        colorLimits = colorBounds().empty( 4, 0) %% 1 = R 2 = G 3 = B 4 = Luminance
        color = zeros(1,3, 'uint8');
    end
    
    methods
        function result = checkValues(obj, RGB, luminance)
            result = true;
            for x = 1:3
                if (obj.colorLimits(1,x).max > RGB(1,x)) | (obj.colorLimits(1,x).min < RGB(1,x))
                    result = false;
                    return;
                end
                
            end
            if (obj.colorLimits(1,4).max > luminance) | (obj.colorLimits(1,4).min < luminance)
                    result = false;
                    return;
            end
        end
        function result = vectorCheckValues(obj, RGB, luminance)
            
            
            R = (RGB(:,:,1) < obj.colorLimits(1,1).max) & (RGB(:,:,1) > obj.colorLimits(1,1).min);
            G = (RGB(:,:,2) < obj.colorLimits(1,2).max) & (RGB(:,:,2) > obj.colorLimits(1,2).min);
            B = (RGB(:,:,3) < obj.colorLimits(1,3).max) & (RGB(:,:,3) > obj.colorLimits(1,3).min);
            L = (luminance < obj.colorLimits(1,4).max) & (luminance > obj.colorLimits(1,4).min);
            result = R & G & B & L;
            result = horzcat(result, result, result);
            
        end
        
        function [result, processedImage] = vectorCheckValuesAndSimpleProcessImage(obj, RGB, luminance)
            [a,b,c] = size(RGB);
            processedImage = zeros(a,b,c);
            R = (RGB(:,:,1) < obj.colorLimits(1,1).max) & (RGB(:,:,1) > obj.colorLimits(1,1).min);
            G = (RGB(:,:,2) < obj.colorLimits(1,2).max) & (RGB(:,:,2) > obj.colorLimits(1,2).min);
            B = (RGB(:,:,3) < obj.colorLimits(1,3).max) & (RGB(:,:,3) > obj.colorLimits(1,3).min);
            L = (luminance < obj.colorLimits(1,4).max) & (luminance > obj.colorLimits(1,4).min);
            result = R & G & B & L;
            processedImage(:,:,1) = result .* obj.color(1,1);
            processedImage(:,:,2) = result .* obj.color(1,2);
            processedImage(:,:,3) = result .* obj.color(1,3);
            
            %processedImage = horzcat(processedRed, processedGreen, processedBlue);
            %result = horzcat(result, result, result);
        end
        function [result, processedImage, trueCount] = vectorCheckValuesAndSimpleProcessImageANDSum(obj, RGB, luminance)
            [a,b,c] = size(RGB);
            processedImage = zeros(a,b,c);
            R = (RGB(:,:,1) < obj.colorLimits(1,1).max) & (RGB(:,:,1) > obj.colorLimits(1,1).min);
            G = (RGB(:,:,2) < obj.colorLimits(1,2).max) & (RGB(:,:,2) > obj.colorLimits(1,2).min);
            B = (RGB(:,:,3) < obj.colorLimits(1,3).max) & (RGB(:,:,3) > obj.colorLimits(1,3).min);
            L = (luminance < obj.colorLimits(1,4).max) & (luminance > obj.colorLimits(1,4).min);
            result = R & G & B & L;
            processedImage(:,:,1) = result .* obj.color(1,1);
            processedImage(:,:,2) = result .* obj.color(1,2);
            processedImage(:,:,3) = result .* obj.color(1,3);
            Count = cumsum(result);
            trueCount = max(Count);
            trueCount = cumsum(trueCount);
            trueCount = max(trueCount);
            %processedImage = horzcat(processedRed, processedGreen, processedBlue);
            %result = horzcat(result, result, result);
        end
        function [result, processedImage, trueCount] = vectorCheckValuesAndSimpleProcessImageANDSumANDExcludeBadCore(obj, RGB, luminance, BadCore)
            [a,b,c] = size(RGB);
            processedImage = zeros(a,b,c);
            badCoreColor = [255 0 0];
            for y = 1:2:length(BadCore)
                if (BadCore(y,2) > 1) && (BadCore(y+1,2) > 1)
                    if (BadCore(y,2) <= a) && (BadCore(y+1,2) <= a)
                        processedImage(BadCore(y,2):BadCore(y+1,2),:,1) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,1);
                        %processedImage(BadCore(y,2):BadCore(y+1,2),:,2) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,2);
                        %processedImage(BadCore(y,2):BadCore(y+1,2),:,3) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,3);
                        %also set luminosity to 0 for these intervals
                        %luminosity(BadCore(y,2):BadCore(y+1,2),:) = luminosity(BadCore(y,2):BadCore(y+1,2),:) .* 0;
                    elseif (BadCore(y,2) <= a) && (BadCore(y+1,2) > a) %%Overlaps core image, but goes beyond it
                        processedImage(BadCore(y,2):a,:,1) = processedImage(BadCore(y,2):a,:,1) + badCoreColor(1,1);
                    end
                elseif (BadCore(y,2) < 1) && (BadCore(y+1,2) > 1) %% core is partially overlapping top of core
                    if (BadCore(y+1,2) <= a)
                         processedImage(1:BadCore(y+1,2),:,1) = processedImage(1:BadCore(y+1,2),:,1) + badCoreColor(1,1);
                    else %%entire core is excluded
                        processedImage(:,:,1) = processedImage(:,:,1) + badCoreColor(1,1);
                        
                    end
                end
                
                 
            end
            R = (RGB(:,:,1) < obj.colorLimits(1,1).max) & (RGB(:,:,1) > obj.colorLimits(1,1).min);
            R_Flag = processedImage(:,:,1) == 0;
            G = (RGB(:,:,2) < obj.colorLimits(1,2).max) & (RGB(:,:,2) > obj.colorLimits(1,2).min);
            B = (RGB(:,:,3) < obj.colorLimits(1,3).max) & (RGB(:,:,3) > obj.colorLimits(1,3).min);
            L = (luminance < obj.colorLimits(1,4).max) & (luminance > obj.colorLimits(1,4).min);
            result = R & G & B & L & R_Flag;
            processedImage(:,:,1) = result .* obj.color(1,1);
            processedImage(:,:,2) = result .* obj.color(1,2);
            processedImage(:,:,3) = result .* obj.color(1,3);
            Count = cumsum(result);
            trueCount = max(Count);
            trueCount = cumsum(trueCount);
            trueCount = max(trueCount);
            %processedImage = horzcat(processedRed, processedGreen, processedBlue);
            %result = horzcat(result, result, result);
        end
        %%Use cumsum to return the proportions for the category
    end
    
end

