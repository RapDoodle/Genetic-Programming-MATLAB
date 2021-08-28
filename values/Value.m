classdef Value < Node
    
    properties
        relatedEnvVar
        value
        valueType
        % 1 for int and 2 for double
    end
    
    methods
        function node = Value(relatedEnvVar, returnType)
            if nargin < 1
                relatedEnvVar = 'unknown';
            end
            if nargin < 2
                returnType = 'unknown';
            end
            node = node@Node(returnType, 1);
            node.relatedEnvVar = relatedEnvVar;
            node.appendLookupName('Value');
        end
        
        function init(~)
            
        end
        
        function output = exec(node, ~)
            output = node.value;
        end
        
        function grow(~, ~)
            % Constants does not grow
        end
        
        function summary(node, ~)
            fprintf("" + node.value);
        end
        
        function newNode = clone(node, ~)
            newNode = copy(node);
        end
    end
end

