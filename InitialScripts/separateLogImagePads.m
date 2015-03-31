function [  ] = separateLogImagePads( filename, numberOfPads, padWidth)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%load image log
imageData = imread(filename);
%Calc Luminosity
luminosity= imageData(:,:,1) .* 0.2126 + imageData(:,:,2) .* 0.7152 + imageData(:,:,3) .* 0.0722;
%%get size params of image
[a,b, ~] = size(imageData);



%numberOfPads = 6;
%padWidth = 15;
padLuminosities = cell(1,6);
padImages = cell(1,6);

%%Separate out each image pad into a sep. image
h_1 = waitbar(1/numberOfPads,'Working on pad images');
for y = 1:6
    padLuminosities{1,y} = zeros(a,padWidth);
    padImages{1,y} = uint8(zeros(a,padWidth,3));
    count = 0;
    flag = false;
    edges = zeros(1,1); %counts the 'right' side edge
    %search for image of 'interest' by counting edges between null and data
    for z = 1:b
        if luminosity(1,z) ~= 254
            if ~flag
               flag = true;
               
                
            end
        else
            if flag
               count = count + 1;
               edges(count,1) = z;
               flag = false;
            end
        end    
    end
    %%Previous line Edge
    %use a fixed width (minimum pixel width of the pad image) from the edge
    %to populate the separate image array
    previousEdge = edges(y,1);
    searchDistance = 10;
    h_2 = waitbar(1/a, 'Making single pad image');
    for x = 1:a
     %follow the edge down the image, continue populating separated image
        for z = previousEdge - searchDistance : previousEdge + searchDistance
            if z < 1
               index = b + z; 
            elseif z > b
               index = z - b; 
            else
               index = z; 
            end
            if luminosity(x,index) == 254
                previousEdge = index - 1;
                if previousEdge < 1
                  previousEdge =  b - index;
                elseif previousEdge > b
                  previousEdge =  index - b;    
                end
                break;
            end
        end
        counter = 0;
        for z = previousEdge - padWidth : previousEdge
            if z < 1
               index = b + z; 
            elseif z > b
               index = z - b; 
            else
               index = z; 
            end
            counter = counter + 1;
            padLuminosities{1,y}(x,counter) = luminosity(x,index);
            padImages{1,y}(x,counter,:) = imageData(x,index,:);

        end
          waitbar(x/a,h_2, 'Making single pad image');
    end   
%%Save the output image(s)
close(h_2);
waitbar(y/numberOfPads,h_1, 'Still working on pad images');
filename2 = strcat(filename,'singlePadImage',mat2str(y),'.png');
imwrite(padImages{1,y},filename2);
end
close(h_1);

end

