classdef ChaoticSignal < Signal
    
    properties
        value 
        % Expected in [-0.5, 0.5]
        chaoticValue
    end
    
    methods
        function node = ChaoticSignal()
            node = node@Signal();
            node.appendLookupName('ChaoticSignal');
        end
        
        function init(node)
            node.value = rand() / 2.5 - 0.2;
        end
        
        function output = exec(node, ~)
            output = leeOscillator(node.value);
        end
        
        function mutate(node, ~, options)
            if rand() < options.mutationRate
                node.value = node.value + rand() / 100;
            end
        end
        
        function summary(node, level)
            newLine(level);
            fprintf("RETURN LEE-OSCILLATOR(" + node.value + ")");
        end
        
        function grow(~, ~)
            % Endpoints does not grow
        end
    end
end

