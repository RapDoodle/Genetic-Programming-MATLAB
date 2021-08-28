classdef LessEqual < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.LessEqual
    
    properties
    end
    
    methods
        function node = LessEqual()
            node = node@BinaryRelationalOperator('LessEqual', "<=");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) <= node.rhs.exec(env);
        end
    end
end

