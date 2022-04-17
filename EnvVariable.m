classdef EnvVariable < Node
    % EnvVariable are variables that will be used during execution
    % Lookupname:
    %   EnvVariable.<VariableName>
    
    properties
        fieldName
        
        valuesType
        % 1: discrete, 2: continuous
        
        % For bounded variables
        lowerBound
        % Lower bound of the variable
        upperBound
        % Upper bound of the variable
        
        % For enumerated variables
        allowedValues = {}
        % A cell that enumerates all the values allowed
    end
    
    methods
        function node = EnvVariable(fieldName, valuesType, returnType, ...
                arg1, arg2, requiredTags)
            % The constructor for environment variables
            % Arguments:
            %   fieldName: The name of the field. The identifier that
            %       is used to locate the environment variable from the
            %       context structure.
            %   valuesType: The type of the environment variable. Can be
            %       either 'enumerated' or 'bounded'.
            %   returnType: The return type. Could be any type that the
            %       environment variable returns.
            %   arg1: A shared variable. When valuesType is set to 
            %       'enumerated', the field should contain the list of
            %       allowed values. When the field valuesType is set to
            %       'bounded', the lower bound of the variable's range
            %       should be provided.
            %   arg2: Only need to be specified when the field valuesType 
            %       is set to 'continuous'. In such case, provide the upper
            %       bound of the variable's range.
            node = node@Node(returnType, 1);
            
            node.appendLookupName('EnvVariable');
            node.appendLookupName(fieldName);
            
            node.fieldName = fieldName;
            
            if strcmp(valuesType, 'enumerated')
                node.valuesType = 1;
                node.allowedValues = arg1;
            elseif strcmp(valuesType, 'bounded')
                node.valuesType = 2;
                node.lowerBound = arg1;
                node.upperBound = arg2;
            else
                error("Unkown argument for valuesType.");
            end
            
            if nargin >= 6
                node.addRequiredTags(requiredTags);
            end
        end
        
        function init(~)
            
        end
        
        function output = exec(node, env)
            output = getfield(env, node.fieldName);
        end
        
        function grow(~, ~)
            % Environment variables does not grow
        end
        
        function summary(node, ~)
            fprintf("" + node.fieldName);
        end
    end
end

