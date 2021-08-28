classdef Operator < Node
    % The class for Operator
    % This is an abstract class that can not be instantiated.
    
    properties
    end
    
    methods
        function node = Operator(returnType, requiredHeight)
            node = node@Node(returnType, requiredHeight);
            node.appendLookupName('Operator');
        end
        
        function init(node)
            
        end
    end
end

