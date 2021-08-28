classdef And < BinaryLogicalOperator
    
    properties
    end
    
    methods
        function node = And()
            node = node@BinaryLogicalOperator('And', "&&");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) && node.rhs.exec(env);
        end
    end
end

