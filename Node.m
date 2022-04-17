classdef Node < handle
    % The class for Node objects.
    % This is an abstract class that can not be instantiated
    
    properties
        requiredHeight
        % The height required for the node to be valid. Default: 1
        
        lookupName = {}
        % The name used to lookup the node type to determine the 
        % available types of nodes
        
        childrenKeys = {}
        % A cell of the name of the child or children the node has
        
        returnType
        % The expected return type of the node
        
        template
        % The template object for guiding the construction of the tree
        
        tags = {}
        % A cell of tags.
        
        requiredTags = {}
        % A cell of required tags.
        
        excludedTags = {}
        % A cell of tags that should be excluded.
    end
    
    methods
        function node = Node(returnType, requiredHeight)
            % The constructor of the Node object
            % Arguments:
            %   returnType: The type it is expected to return
            %   requiredHeight: The height required for the node to 
            %       be valid. Default value: 1
            if nargin >= 1
                node.returnType = returnType;
            end
            if nargin >= 2
                node.requiredHeight = requiredHeight;
            else
                node.requiredHeight = 1;
            end
        end
        
        function setTemplate(node, template)
            if ~isa(template, 'Template')
                error("Not a template object.");
            end
            node.template = template;
        end
        
        function initChildren(node, childrenKeys)
            % Initialize the children dictionary (containers.Map) object
            % with predefined keys.
            % Arguments:
            %   childrenKeys: A cell of the name of the child or children 
            %   the node has
            node.childrenKeys = childrenKeys;
        end
        
        function appendLookupName(node, name)
            node.lookupName{end+1} = name;
        end
        
        
        function lookupName = getLookupName(node)
            lookupName = join(node.lookupName, '.');
            lookupName = lookupName{1};
        end
        
        function grow(node, maxHeight)
            % Grow the tree to the maximum suggested height.
            if maxHeight < node.requiredHeight
                error("Not enough height.");
            end
            
            n = length(node.childrenKeys);
            
            % Find a node for each child
            for i=1:n
                childrenKey = node.childrenKeys{i};
                while true
                    node.(childrenKey) = ...
                    node.template.getNode( ...
                    node.lookupName, childrenKey, maxHeight-1, true, ...
                    128, 0, node.tags);
                    if strcmp(childrenKey, 'rhs') && isa(node.(childrenKey), 'Value')
                        % If the lower bound and upper bound is the same, 
                        % ignore its rhs
                        if node.lhs.valuesType == 2 && ...
                                node.lhs.lowerBound == node.lhs.upperBound
                            continue;
                        end
                    end
                    break;
                end
                
                node.(childrenKey).addRequiredTags(node.requiredTags);
            end
            
            % Recursively grow the nodes
            for i=1:n
                childNode = node.(node.childrenKeys{i});
                childNode.grow(maxHeight-1);
            end
            
            % Initialize the nodes
            for i=1:n
                if strcmp(node.childrenKeys{i}, 'rhs') && ...
                        isa(node.('rhs'), 'Value')
                    lhsNode = node.lhs;
                    rhsNode = node.rhs;
                    % Create the right type of Constant
                    if lhsNode.valuesType == 1
                        % Discrete variables
                        rhsNode = EnumeratedValue();
                        rhsNode.init( ...
                            lhsNode.fieldName, ...
                            lhsNode.allowedValues, ...
                            lhsNode.returnType);

                    elseif lhsNode.valuesType == 2
                        % Continuous variables
                        rhsNode = BoundedValue();
                        rhsNode.init( ...
                            lhsNode.fieldName, ...
                            lhsNode.lowerBound, ...
                            lhsNode.upperBound, ...
                            lhsNode.returnType);
                    else
                        error("Unknown valuesType.");
                    end
                    node.(node.childrenKeys{i}) = rhsNode;
                else
                    childNode = node.(node.childrenKeys{i});
                    childNode.init();
                end
            end
        end
        
        function depth = getDepth(node)
            n = length(node.childrenKeys);
            if n == 0
                depth = 1;
            else
                maxDepth = -1;
                for i=1:n
                    childrenKey = node.childrenKeys{i};
                    depth = node.(childrenKey).getDepth();
                    if depth > maxDepth
                        maxDepth = depth;
                    end
                end
                depth = maxDepth + 1;
            end
        end
        
        function nodes = getChildrenNodes(node)
            n = length(node.childrenKeys);
            nodes = cell(n, 1);
            for i=1:n
                nodes{i} = node.(node.childrenKeys{i});
            end
        end
        
        function nodes = getNodesByDistance(node, distance)
            if distance == 0
                nodes = {node};
            elseif distance == 1
                nodes = node.getChildrenNodes();
            else
                nodes = {};
                childrenNodes = node.getChildrenNodes();
                n = length(node.childrenKeys);
                for i=1:n
                    retNodes = childrenNodes{i}.getNodesByDistance(distance-1);
                    if ~isempty(retNodes)
                        nodes = cat(1, [nodes(:)', retNodes(:)']);
                    end
                end
            end
        end
        
        function success = crossover(nodeA, nodeB, ~)
            success = false;
            depthA = nodeA.getDepth();
            depthB = nodeB.getDepth();
            maxAttempts = depthA * depthB;
            for attempt=1:maxAttempts
                % Randomly select a node from tree A.
                randDistanceA = randi([0, depthA-1]);
                nodesA = nodeA.getNodesByDistance(randDistanceA);
                selectedNodeIdxA = randi([1, length(nodesA)]);
                selectedNodeA = nodesA{selectedNodeIdxA};
                if isempty(selectedNodeA.childrenKeys)
                    % The node does not contain any child, move on to the
                    % next attempt.
                    continue;
                end
                
                numChildren = length(selectedNodeA.childrenKeys);
                randomChildIdx = randi([1, numChildren]);
                randomChildKey = selectedNodeA.childrenKeys{randomChildIdx};
                
                % Randomly select a node from tree B.
                randDistanceB = randi([0, depthB-1]);
                nodesB = nodeB.getNodesByDistance(randDistanceB);
                selectedNodeIdxB = randi([1, length(nodesB)]);
                selectedNodeB = nodesB{selectedNodeIdxB};
                
                % Check if selected node B is a valid node for becoming 
                % the child of A.
                allowedNodes = nodeA.template.getNodes( ...
                    selectedNodeA.lookupName, randomChildKey, true, 128, 0);
                numAllowedNodes = length(allowedNodes);
                allowedHeight = depthA - randDistanceA - 1;
                for i=1:numAllowedNodes
                    if strcmp(class(selectedNodeB), class(allowedNodes{i}))
                        % Check whether the height satisfies the
                        % requirements
                        if selectedNodeB.getDepth() > allowedHeight
                            % Break the loop without setting success to
                            % true.
                            break;
                        end
                        
                        % Check if it is a valid crossover in terms of the
                        % requiredTags
                        if ~Template.checkTagsValidity( ...
                                selectedNodeA.tags, ...
                                selectedNodeB.requiredTags, ...
                                selectedNodeB.excludedTags)
                            break;
                        end
                        
                        % Verified the node is valid
                        selectedNodeA.(randomChildKey) = ...
                            deepcopy(selectedNodeB);
                        
                        success = true;
                        break;
                    end
                end
                
                if success
                    break;
                end
            end
        end
        
        function mutate(node, opt, maxHeight)
            % Mutate the node. The default behaviors for nodes. Can be
            % overridden if needed.
            % The mutation is done by replacing regrowing the current
            % node. The node itself (eg. the operator >=) will not be
            % changed. Only the children is changed.
            % Arguments:
            %   opt: A struct containing the following options
            %     - maxHeight: The maximum height allowed
            %     - mutationRate: The rate of mutation. For example, 0.02
            %       for 2%.
            %     - mutationStd: [Optional] A struct containing the
            %       mutation standard deviation of mutation for values 
            %       or signals. For each entry, it should contain the 
            %       name of the related environment variable and the 
            %       standard deviation of mutation. For example, 
            %       mutationStd.RSI = 1.
            %   maxHeight: The maximum height allowed. No need to specify.
            %       as the function will automatically populate the
            %       variable with values from the opt object
            if nargin < 3
                maxHeight = opt.maxHeight;
            end
            if rand() < opt.mutationRate
                % The current node is chosen to mutate. Then try to grow
                try
                    node.grow(opt.maxHeight-1);
                catch
                    
                end
            else
                n = length(node.childrenKeys);
                for i=1:n
                    childrenKey = node.childrenKeys{i};
                    childNode = node.(childrenKey);
                    childNode.mutate(opt, maxHeight-1);
                end
            end
        end
        
        function appendTags(node, tags)
            % Append tags to the current node.
            % Note:
            %   Only tags that are not present in the cell will be added.
            % Arguments:
            %   tags: A cell of tags.
            node.tags = ...
                unique(cat(1, [node.tags(:)', tags(:)']));
        end
        
        function addRequiredTags(node, tags)
            % Add required tags
            % Note:
            %   Only tags that are not present in the cell will be added.
            % Arguments:
            %   tags: A cell of tags that needs to be the prerequisite.
            node.requiredTags = ...
                unique(cat(1, [node.requiredTags(:)', tags(:)']));
        end
        
        function addExcludedTags(node, tags)
            % Add excluded tags
            % Note:
            %   Only tags that are not present in the cell will be added.
            % Arguments:
            %   tags: A cell of tags that needs to be the excluded.
            node.excludedTags = ...
                unique(cat(1, [node.excludedTags(:)', tags(:)']));
        end
    end
    
    methods(Abstract)
        init(node)
        % Initialize the node.
        
        output = exec(node, env)
        % Execute the current node.
        
        summary(node, level)
        % Generate the pseudocode of the current tree
        % Arguments:
        %   level: The indentation level. Starts from 1. A 0 indicates
        %       there should not be a new line at the beginning of the 
        %       current level.
    end
end

