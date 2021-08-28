classdef Max < Function
    
    properties
    end
    
    methods
        function node = Max()
            node = node@Function("Max", "double");
            node.appendLookupName('Avg');
        end
        
        function output = exec(~, val)
            output = max(val);
        end
    end
end

