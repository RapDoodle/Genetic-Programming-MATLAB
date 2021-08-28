classdef Statement < Node
    % Looup name: Statement
    % The class for Statement objects.
    % This is an abstract class that can not be instantiated
    
    properties
    end
    
    methods
        function node = Statement(returnType, requiredHeight)
            node = node@Node(returnType, requiredHeight);
            node.appendLookupName('Statement');
        end
    end
end

