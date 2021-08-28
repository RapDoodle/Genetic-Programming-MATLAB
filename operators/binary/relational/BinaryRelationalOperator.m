classdef BinaryRelationalOperator < BinaryOperator
    
    properties
    end
    
    methods
        function node = BinaryRelationalOperator(lookupName, operator)
            node = node@BinaryOperator(operator, 'logical', 2);
            node.appendLookupName('BinaryRelationalOperator');
            node.appendLookupName(lookupName);
        end
    end
end

