function [ avgLuminosity ] = avgLuminosityAtDepthForHeight( luminosity, depth, avgHeight )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
luminosityFlag = (luminosity(:,3) <= (depth +  avgHeight)) &  (luminosity(:,3) >= (depth -  avgHeight));
avgLuminosity = mean(luminosity(luminosityFlag, 2));

end

