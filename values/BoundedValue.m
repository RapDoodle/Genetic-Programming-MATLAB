classdef BoundedValue < Value
    % The values used during exections. Usually initialized randomly 
    % and chagned by means of mutation.
    % Lookup Name:
    %   Value.BoundedValue
    
    properties
        % The following variables should be lazy initialized
        lowerBound
        upperBound
    end
    
    methods
        function node = BoundedValue(relatedEnvVar, returnType)
            if nargin < 1
                relatedEnvVar = 'unknown';
            end
            if nargin < 2
                returnType = 'unknown';
            end
            node = node@Value(relatedEnvVar, returnType);
            node.appendLookupName('BoundedValue');
        end
        
        function init(node, relatedEnvVar, lowerBound, upperBound, returnType)
            % The initializer for bounded values
            %
            % Arguments:
            %   relatedEnvVar: The name of the environment variable
            %       related.
            %   lowerBound: A shared variable. When valuesType is set to 
            %       'enumerated', the field should contain the list of
            %       allowed values. When the field valuesType is set to
            %       'bounded', the lower bound of the variable's range
            %       should be provided.
            %   upperBound: Only need to be specified when the field  
            %       valuesType is set to 'bounded'. In such case, 
            %       provide the upper bound of the variable's range.
            %   returnType: The return type. Could be any type that the
            %       environment variable returns.
            node.relatedEnvVar = relatedEnvVar;
            node.lowerBound = lowerBound;
            node.upperBound = upperBound;
            node.returnType = returnType;
            
            if strcmp(returnType, 'int')
                node.valueType = 1;
                node.value = randi([node.lowerBound, node.upperBound]);
            elseif strcmp(returnType, 'double')
                node.valueType = 2;
                node.value = node.lowerBound + ...
                    (node.upperBound - node.lowerBound) * rand();
            else
                error("Unknown valuesType.");
            end
        end
        
        function mutate(node, ~, options)
            % Arguments:
            %   mutationStd:
            %     The standard deviation of each mutation. By default, 1.
            %     New value is calculated using 
            %         value = value + mutationStd * randn();
            %     Extra mechanism is implemented to ensure the value 
            %     after mutation stays within in the range:
            %         ([lowerBound, upperBound])
            if rand() < options.mutationRate
                success = false;
                
                for i=1:50
                    if node.valueType == 1
                        % Value type: int
                        newVal = node.value + ...
                            round(getfield(options.mutationStd, node.relatedEnvVar) * randn());
                    else
                        % Value type: double
                        newVal = node.value + ...
                            getfield(options.mutationStd, node.relatedEnvVar) * randn();
                    end
                    
                    if newVal <= node.upperBound && newVal >= node.lowerBound
                        success = true;
                        node.value = newVal;
                        break;
                    end
                end
                
                if ~success
                    error("Maximum attempt for mutation reached.");
                end
            end
        end
    end
end

