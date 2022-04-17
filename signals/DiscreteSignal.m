classdef DiscreteSignal < Signal
    % DiscreteSignals are signals that take in discrete values.
    % Lookup Name:
    %   Signal.DiscreteSignal
    
    properties
        allowedValues
    end
    
    methods
        function node = DiscreteSignal(allowedValues)
            node = node@Signal();
            node.appendLookupName('DiscreteSignal');
            node.allowedValues = allowedValues;
        end
        
        function init(node)
            n = length(node.allowedValues);
            if n > 0
                idx = randi(length(node.allowedValues));
                node.signal = node.allowedValues{idx};
            end
        end
        
        function mutate(node, options, ~)
            if rand() < options.terminalMutationRate
                node.init();
            end
        end
    end
end

