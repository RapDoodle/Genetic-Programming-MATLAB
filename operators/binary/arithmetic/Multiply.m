classdef Multiply < BinaryArithmeticOperator
    
    properties
    end
    
    methods
        function node = Multiply()
            node = node@BinaryArithmeticOperator('Multiply', "*");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) * node.rhs.exec(env);
        end
    end
end

