classdef IfThenElse < Statement
    % Lookup name: Statement.IfThenElse
    % IfThenElse contains three nodes:
    %   ifNode: The node evaluates an expression that should return
    %       either true or false.
    %   thenNode: The node will be executed when the ifNode returned
    %       true. The node expectes a Signal object to be returned.
    %   elseNode: The node will be executed when the elseNode returned
    %       false. The node expectes a Signal object to be returend.
    
    properties
        ifNode
        thenNode
        elseNode
    end
    
    methods
        function node = IfThenElse()
            node = node@Statement("Signal", 3);
            node.appendLookupName('IfThenElse');
            node.initChildren({'ifNode', 'thenNode', 'elseNode'});
        end
        
        function init(node)
            
        end
        
        function output = exec(node, env)
            % If the ifNode returned true, execute the thenNode.
            % Otherwise, execute the elseNode.
            if node.ifNode.exec(env)
                output = node.thenNode.exec(env);
            else
                output = node.elseNode.exec(env);
            end
        end
        
        function newNode = clone(node, recursive)
            if nargin < 2
                recursive = true;
            end
            newNode = copy(node);
            newNode.ifNode = node.ifNode.clone(recursive);
            newNode.thenNode = node.thenNode.clone(recursive);
            newNode.elseNode = node.elseNode.clone(recursive);
        end
        
        function summary(node, level)
            % Generate the pseudocode for the current tree
            if nargin < 2
                level = 1;
            end
            
            newLine(level);
            fprintf("IF ");
            node.ifNode.summary(0);
            node.thenNode.summary(level+1);
            
            newLine(level);
            fprintf("ELSE");
            node.elseNode.summary(level+1);
            
            newLine(level);
            fprintf("ENDIF");
            endOfSummary(level);
        end
        
        function lookupName = getLookupName(~)
            lookupName = "Statement.IfThenElse";
        end
    end
end

