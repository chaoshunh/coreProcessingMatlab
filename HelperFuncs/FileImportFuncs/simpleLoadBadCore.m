function [ BadCore ] = simpleLoadBadCore( filename, ftPerPix, TopDepth)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 %read bad core log
        [BadCore(:,1),~] = importPetrelDescreteLog(filename);
        %convert from MD intervals to pixel intervals
        BadCore(:,2) = round((BadCore(:,1) - TopDepth)/ftPerPix);

end

