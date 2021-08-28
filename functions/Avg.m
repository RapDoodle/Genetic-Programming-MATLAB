classdef Avg < Function
    
    properties
    end
    
    methods
        function node = Avg()
            node = node@Function("Avg", "double");
            node.appendLookupName('Avg');
        end
        
        function output = exec(~, val)
            output = mean(val);
        end
    end
end

