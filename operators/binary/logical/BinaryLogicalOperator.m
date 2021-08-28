classdef BinaryLogicalOperator < BinaryOperator
    
    properties
    end
    
    methods
        function node = BinaryLogicalOperator(lookupName, operator)
            node = node@BinaryOperator(operator, 'logic', 3);
            node.appendLookupName('BinaryLogicalOperator');
            node.appendLookupName(lookupName);
        end
        
        function summary(node, level)
            newLine(level);
            
            fprintf("(");
            node.lhs.summary(0);
            fprintf(" " + node.operator + " ");
            node.rhs.summary(0);
            fprintf(")");
            
            endOfSummary(level);
        end
    end
end

