classdef Subtract < BinaryArithmeticOperator
    
    properties
    end
    
    methods
        function node = Subtract()
            node = node@BinaryArithmeticOperator('Subtract', "-");
        end
        
        function output = exec(node, env)
            output = node.lhs.exec(env) - node.rhs.exec(env);
        end
    end
end

