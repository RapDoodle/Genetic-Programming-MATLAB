classdef Function < Node
    
    properties
        funcName
    end
    
    methods
        function node = Function(funcName, returnType)
            node = node@Node(returnType);
            node.funcName = funcName;
            node.appendLookupName('Function');
        end
        
        function init(~)
            
        end
        
        function summary(node, level)
            newLine(level);
            fprintf(node.funcName + " (X)");
        end
        
        function newNode = clone(node, ~)
            newNode = copy(node);
        end
    end
end

