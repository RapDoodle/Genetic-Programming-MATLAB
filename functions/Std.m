classdef Std < Function
    
    properties
    end
    
    methods
        function node = Std()
            node = node@Function("Std", "double");
            node.appendLookupName('Std');
        end
        
        function output = exec(~, val)
            output = std(val);
        end
    end
end

