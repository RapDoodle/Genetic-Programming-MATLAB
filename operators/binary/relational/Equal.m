classdef Equal < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.Equal
    
    properties
    end
    
    methods
        function node = Equal()
            node = node@BinaryRelationalOperator('Equal', "==");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) == node.rhs.exec(env);
        end
    end
end

