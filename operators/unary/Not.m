classdef Not <UnaryOperator
    
    properties
    end
    
    methods
        function obj = Not()
            obj = obj@UnaryOperator('logical');
            node.appendLookupName('Not');
        end
        
        function output = exec(node, env)
            output = ~node.operand.exec(env);
        end
    end
end

