classdef Mod < BinaryArithmeticOperator
    
    properties
    end
    
    methods
        function node = Mod()
            node = node@BinaryArithmeticOperator('Mod', "%");
        end
        
        function output = exec(node, env)
            output = mod(node.lhs.exec(env), node.rhs.exec(env));
        end
    end
end

