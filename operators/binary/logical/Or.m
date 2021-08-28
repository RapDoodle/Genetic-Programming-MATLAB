classdef Or < BinaryLogicalOperator
    
    properties
    end
    
    methods
        function node = Or()
            node = node@BinaryLogicalOperator('Or', "||");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) || node.rhs.exec(env);
        end
    end
end

