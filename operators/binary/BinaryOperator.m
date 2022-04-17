classdef BinaryOperator < Operator
    % The class for BinaryOperator
    % This is an abstract class that can not be instantiated.
    
    properties
        lhs
        rhs
        operator
    end
    
    methods
        function node = BinaryOperator(operator, returnType, requiredHeight)
            node = node@Operator(returnType, requiredHeight);
            node.appendLookupName('BinaryOperator');
            node.operator = operator;
            node.initChildren({"lhs", "rhs"});
        end
        
        function summary(node, level)
            newLine(level);
            
            node.lhs.summary(0);
            fprintf(" " + node.operator + " ");
            node.rhs.summary(0);
            
            endOfSummary(level);
        end
    end
end

