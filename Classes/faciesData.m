classdef faciesData
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        faciesCode = nan;
        logData = zeros(1,8);
        plugData = zeros(1,6);
        shiftedLog_PlugData = zeros(1,14);
        
    end
    
    methods
        function obj = faciesData(faciesCode, logData, plugData)
            if nargin > 0
                obj.faciesCode = faciesCode;
                obj.logData = logData;
                obj.plugData = plugData;
            end
        end
    end
    
end

