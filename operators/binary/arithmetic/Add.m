classdef Add < BinaryArithmeticOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryArithmeticOperator.Add
    
    properties
    end
    
    methods
        function node = Add()
            node = node@BinaryArithmeticOperator('Add', "+");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) + node.rhs.exec(env);
        end
    end
end

