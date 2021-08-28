classdef Less < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.Less
    
    properties
    end
    
    methods
        function node = Less()
            node = node@BinaryRelationalOperator('Less', "<");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) < node.rhs.exec(env);
        end
    end
end

