classdef UnaryOperator < Operator
    
    properties
        operand
    end
    
    methods
        function node = UnaryOperator(returnType)
            node = node@Operator(returnType, 2);
            node.appendLookupName('UnaryOperator');
        end
    end
end

