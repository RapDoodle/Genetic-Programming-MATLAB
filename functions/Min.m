classdef Min < Function
    
    properties
    end
    
    methods
        function node = Min()
            node = node@Function("Min", "double");
            node.appendLookupName('Min');
        end
        
        function output = exec(~, val)
            output = min(val);
        end
    end
end

