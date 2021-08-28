classdef Template < handle
    
    properties
        library
    end
    
    methods
        function tpl = Template(library)
            if nargin > 0
                tpl.library = library;
            else
                tpl.library = containers.Map();
            end
        end
        
        function output = getNodes(tpl, nodeLookupName, child, ...
                recursive, maxRecursiveLevel, skip)
            % Returns the nodes allowed for the node specified
            % Note:
            %   The template hierarchy works in the form of override, not
            %       inheritance.
            % Arguments:
            %   nodeLookupName: The node's lookup name in the form of a 
            %       cell (excluding the child name).
            %   childName: The name of the node's child. In case the child
            %       is not concerned, pass an empty string "".
            %   recursive: Recursively retrieve nodes available. This 
            %       option is by default, set to false.
            %   maxRecursiveLevel: The depth of recursive calls. By 
            %       default, this is set to 1. This argument has no effect 
            %       if 'recursive' is set to false.
            %   skip: The level of hierarchy that will be skipped. By
            %       default, 0 (not level no be skipped).
            if nargin < 4
                recursive = false;
            end
            if nargin < 5
                maxRecursiveLevel = 1;
            end
            if nargin < 6
                skip = 0;
            end
            
            nodeLookupName = nodeLookupName(1:(end-skip));
            key = '';
            found = false;
            recursiveCount = 0;
            
            while ~isempty(nodeLookupName)
                key = join(nodeLookupName, '.');
                key = key{1};
                if ~isempty(child)
                    key = convertCharsToStrings(key);
                    key = key + "." + child;
                end
                if isKey(tpl.library, key)
                    found = true;
                    break;
                elseif ~recursive
                    break;
                else
                    % Not a key, but recursive is on
                    recursiveCount = recursiveCount + 1;
                    if recursiveCount > maxRecursiveLevel
                        break;
                    end
                    nodeLookupName = nodeLookupName(1:(end-1));
                end
            end
            
            if ~found
                error("No available nodes found.");
            end
            
            output = tpl.library(key);
        end
        
        function set(tpl, key, val)
            if ~isa(val, 'cell')
                error("Not a cell");
            end
            tpl.library(key) = val;
        end
        
        function output = getNode(tpl, nodeLookupName, child, ...
                maxHeight, recursive, maxRecursiveLevel, skip, tags)
            % Returns a random node from the allowed nodes specified
            % Note:
            %   The template hierarchy works in the form of override, not
            %       inheritance.
            % Arguments:
            %   maxHeight: the required height of the node to be valid
            %       default value: 1
            %   nodeLookupName: The node's lookup name in the form of a 
            %       cell (excluding the child name).
            %   childName: The name of the node's child. In case the child
            %       is not concerned, pass an empty string "".
            %   recursive: Recursively retrieve nodes available. This 
            %       option is by default, set to false.
            %   maxRecursiveLevel: The depth of recursive calls. By 
            %       default, this is set to 1. This argument has no effect 
            %       if 'recursive' is set to false.
            %   skip: The level of hierarchy that will be skipped. By
            %       default, 0 (not level no be skipped).
            %   tags: The tags of the node.
            if nargin < 4
                maxHeight = 1;
            end
            if nargin < 5
                recursive = false;
            end
            if nargin < 6
                maxRecursiveLevel = 1;
            end
            if nargin < 7
                skip = 0;
            end
            if nargin < 8
                tags = {};
            end
            
            nodeLookupName = nodeLookupName(1:(end-skip));
            key = '';
            found = false;
            recursiveCount = 0;
            
            while ~isempty(nodeLookupName)
                key = join(nodeLookupName, '.');
                key = key{1};
                if child ~= ""
                    key = convertCharsToStrings(key);
                    key = key + "." + child;
                end
                if isKey(tpl.library, key)
                    found = true;
                    break;
                elseif ~recursive
                    break;
                else
                    % Not a key, but recursive is on
                    recursiveCount = recursiveCount + 1;
                    if recursiveCount > maxRecursiveLevel
                        break;
                    end
                    nodeLookupName = nodeLookupName(1:(end-1));
                end
            end
            
            if ~found
                error("No available nodes found for key " + string(key) + ".");
            end
            
            
            list = tpl.library(key);
            n = length(list);
            if n == 0
                error("Empty cell. Please specify for key '" + key + "'.");
            end
            foundValid = false;
            idx = -1;
            maxAttempts = n * 11;
            for i=1:maxAttempts
                % 20 attempts
                idx = randi(n);
                
                % Check whether the height meets the requirement
                if list{idx}.requiredHeight > maxHeight
                    continue;
                end
                
                if ~Template.checkTagsValidity( ...
                        tags, ...
                        list{idx}.requiredTags, ...
                        list{idx}.excludedTags)
                    continue;
                end
                
                foundValid = true;
                break;
            end
            
            if ~foundValid
                % Fallback to linear search
                warning("Using linear search as a fallback option.");
                for i=1:n
                    idx = i;
                    
                    % Check whether the height meets the requirement
                    if list{idx}.requiredHeight > maxHeight
                        continue;
                    end
                    
                    if ~Template.checkTagsValidity( ...
                            tags, ...
                            list{idx}.requiredTags, ...
                            list{idx}.excludedTags)
                        continue;
                    end

                    foundValid = true;
                    break;
                end
                
                if ~foundValid
                    % Still not found
                    error("Maximum of " + maxAttempts + " attempts reached.");
                end
            end
            
            output = copy(list{idx});
            
            % Preload the current template by default
            output.setTemplate(tpl);
            output.appendTags(tags);
            output.addRequiredTags(list{idx}.requiredTags);
        end
    end
    
    methods(Static)
        function valid = checkTagsValidity(tags, requiredTags, excludedTags)
            % Check if the tags contain excluded tags
            tagsLen = length(tags);
            for tagsIdx=1:tagsLen
                if any(ismember(excludedTags, tags{tagsIdx}))
                    % Found forbidden
                    valid = false;
                    return;
                end
            end
            
            % Check if the tags have the required tags
            requiredTagsLen = length(requiredTags);
            for requiredTagsIdx=1:requiredTagsLen
                if ~any(ismember(tags, requiredTags{requiredTagsIdx}))
                    % Found a tag that does not satisfy the
                    % requirements
                    valid = false;
                    return;
                end
            end
            
            valid = true;
        end
    end
end

