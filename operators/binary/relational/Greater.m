classdef Greater < BinaryRelationalOperator
    % Lookup name: 
    %   Operator.BinaryOperator.BinaryRelationalOperator.Greater
    
    properties
    end
    
    methods
        function node = Greater()
            node = node@BinaryRelationalOperator('Greater', ">");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) > node.rhs.exec(env);
        end
    end
end

