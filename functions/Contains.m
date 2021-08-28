classdef Contains < Function
    
    properties
    end
    
    methods
        function node = Contains()
            node = node@Function("Contains", "logic");
            node.appendLookupName('Contains');
        end
        
        function output = exec(~, str, pattern)
            output = contains(str, pattern);
        end
    end
end

