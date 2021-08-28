classdef Signal < Node
    
    properties
        signal
    end
    
    methods
        function node = Signal()
            node = node@Node('Signal', 1);
            % returnType: 'Signal'
            % requiredHeight: 1
            node.appendLookupName('Signal');
        end
        
        function output = exec(node, ~)
            output = node.signal;
        end
        
        function grow(~, ~)
            % Endpoint does not grow
        end
        
        function summary(node, level)
            newLine(level);
            fprintf("RETURN " + node.signal);
        end
        
        function newNode = clone(node, ~)
            newNode = copy(node);
        end
    end
end

