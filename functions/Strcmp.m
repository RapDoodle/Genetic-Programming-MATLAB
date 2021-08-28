classdef Strcmp < Function
    
    properties
    end
    
    methods
        function node = Strcmp()
            node = node@Function("Strcmp", "logic");
            node.appendLookupName('Strcmp');
        end
        
        function output = exec(~, str1, str2)
            output = strcmp(str1, str2);
        end
    end
end

