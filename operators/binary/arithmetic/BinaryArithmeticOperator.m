classdef BinaryArithmeticOperator < BinaryOperator
    
    properties
    end
    
    methods
        function node = BinaryArithmeticOperator(lookupName, operator)
            node = node@BinaryOperator(operator, 'double', 2);
            node.appendLookupName(lookupName);
        end
    end
end

