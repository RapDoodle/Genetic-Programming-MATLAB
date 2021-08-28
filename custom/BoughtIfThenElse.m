classdef BoughtIfThenElse < IfThenElse
    % Lookup name:
    %   Statement.IfThenElse.BoughtIfThenElse
    
    properties
    end
    
    methods
        function node = BoughtIfThenElse()
            node = node@IfThenElse();
            node.appendLookupName('BoughtIfThenElse');
            node.addExcludedTags({'qpl'});
            node.initChildren({'thenNode', 'elseNode'});
        end
        
        function grow(node, maxHeight)
            % Grow the tree to the maximum suggested height.
            if maxHeight < node.requiredHeight
                error("Not enough height.");
            end
            
            node.ifNode = Equal();
            node.ifNode.lhs = EnvVariable("BOUGHT", 'enumerated', 'int', [0, 1]);
            node.ifNode.rhs = EnumeratedValue();
            node.ifNode.rhs.init("BOUGHT", [0, 1], 'int');
            
            if node.ifNode.rhs.value == 1
                trueNode = 'thenNode';
                falseNode = 'elseNode';
            else
                trueNode = 'elseNode';
                falseNode = 'thenNode';
            end
            
            node.(trueNode) = ...
                node.template.getNode( ...
                node.lookupName, 'thenNode', maxHeight-1, true, ...
                128, 0, cat(1, [node.tags(:)', {'qpl'}']));
            node.(trueNode).addRequiredTags({'qpl'});
            
            % The 'false' node should not contain the 'qpl' tag.
            node.(falseNode) = ...
                node.template.getNode( ...
                node.lookupName, 'elseNode', maxHeight-1, true, ...
                128, 0, node.tags);
            
            node.thenNode.init();
            node.elseNode.init();
            
            node.thenNode.grow(maxHeight-1);
            node.elseNode.grow(maxHeight-1);
        end
    end
end

