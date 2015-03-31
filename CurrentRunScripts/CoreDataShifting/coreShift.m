classdef coreShift
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        topMD
        bottomMD
        Shift = 0.0
    end
    
    methods
        function obj = coreShift(topMD, bottomMD, Shift)
            obj.topMD = topMD;
            obj.bottomMD = bottomMD;
            obj.Shift = Shift;
            
        end
    end
    
end

