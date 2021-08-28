classdef GreaterEqual < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.Greater
    
    properties
    end
    
    methods
        function node = GreaterEqual()
            node = node@BinaryRelationalOperator('GreaterEqual', ">=");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) >= node.rhs.exec(env);
        end
    end
end

