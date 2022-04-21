classdef BoundedSignal < Signal
    % BoundedSignal objects can yield values between an interval.
    % Lookup Name:
    %   Signal.BoundedSignal
    
    properties
        lowerBound
        upperBound
        valueType
    end
    
    methods
        function node = BoundedSignal(lowerBound, upperBound, returnType)
            node = node@Signal();
            node.appendLookupName('BoundedSignal');
            if strcmp(returnType, 'int')
                node.valueType = 1;
            elseif strcmp(returnType, 'double') || strcmp(returnType, 'float')
                node.valueType = 2;
            else
                error("Unknown valuesType.");
            end
            node.lowerBound = lowerBound;
            node.upperBound = upperBound;
        end
        
        function init(node)
            if node.valueType == 1
                node.signal = randi([node.lowerBound, node.upperBound]);
            elseif node.valueType == 2
                node.signal = node.lowerBound + ...
                    (node.upperBound - node.lowerBound) * rand();
            end
        end
        
        function mutate(node, options, ~)
            if rand() < options.terminalMutationRate
                if node.valueType == 1
                    node.signal = randi([node.lowerBound, node.upperBound]);
                else
                    node.signal = node.lowerBound + ...
                        (node.upperBound - node.lowerBound) * rand();
                end
            end
        end
    end
end

