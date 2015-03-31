function [ avgLuminosity ] = avgLuminosityAtDepthForHeight( luminosity, depth, avgHeight )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
luminosityFlag = (luminosity(:,1) <= (depth +  avgHeight)) &  (luminosity(:,1) >= (depth -  avgHeight));
avgLuminosity = mean(luminosity(luminosityFlag, 2));

end

