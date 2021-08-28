classdef NotEqual < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.NotEqual
    
    properties
    end
    
    methods
        function node = NotEqual()
            node = node@BinaryRelationalOperator('NotEqual', "!=");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) ~= node.rhs.exec(env);
        end
    end
end

