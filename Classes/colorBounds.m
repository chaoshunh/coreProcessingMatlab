classdef colorBounds
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        max = 0
        min = 0
    end
    
    methods
        function obj = colorBounds(max, min)
            if nargin > 0
                obj.max = max;
                obj.min = min;
            end
        end
    end
    
end

