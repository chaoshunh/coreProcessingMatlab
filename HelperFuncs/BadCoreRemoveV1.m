function [ processedImage, luminosity, BadCore ] = BadCoreRemoveV1( processedImage, luminosity, filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%Exlude Bad (Broken) core from processed image & luminosity
        %bad core RGB color
        badCoreColor = [255 0 0];
        %read bad core log
        [BadCore(:,1),~] = importPetrelDescreteLog(filename);
        %convert from MD intervals to pixel intervals
        BadCore(:,2) = round((BadCore(:,1) - TopDepth)/ftPerPix);
        %set processedImage to the frac/part color
        for y = 1:2:length(BadCore)
            if (BadCore(y,2) > 1) && (BadCore(y+1,2) > 1)
                if (BadCore(y,2) <= c) && (BadCore(y+1,2) <= c)
                    processedImage(BadCore(y,2):BadCore(y+1,2),:,1) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,1);
                    processedImage(BadCore(y,2):BadCore(y+1,2),:,2) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,2);
                    processedImage(BadCore(y,2):BadCore(y+1,2),:,3) = processedImage(BadCore(y,2):BadCore(y+1,2),:,1) + badCoreColor(1,3);
                    %also set luminosity to 0 for these intervals
                    luminosity(BadCore(y,2):BadCore(y+1,2),:) = luminosity(BadCore(y,2):BadCore(y+1,2),:) .* 0;
                end
            end
        end
end

