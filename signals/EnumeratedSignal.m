classdef EnumeratedSignal < Signal
    % EnumeratedSignals are objects that can yield enumerated values.
    % Lookup Name:
    %   Signal.EnumeratedSignal
    
    properties
        allowedValues
    end
    
    methods
        function node = EnumeratedSignal(allowedValues)
            node = node@Signal();
            node.appendLookupName('EnumeratedSignal');
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
            if rand() < options.terminalMutationProb
                node.init();
            end
        end
    end
end

