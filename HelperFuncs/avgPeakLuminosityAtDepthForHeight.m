function [ maxLuminosity ] = avgPeakLuminosityAtDepthForHeight( luminosity, depth, avgHeight )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
luminosityFlag = (luminosity(:,1) <= (depth +  avgHeight)) &  (luminosity(:,1) >= (depth -  avgHeight));
avgLuminosity = mean(luminosity(luminosityFlag, 2));
if ~isnan(avgLuminosity)
maxLuminosity = max(luminosity(luminosityFlag, 2));
else
    maxLuminosity = nan;
end

end

