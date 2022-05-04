classdef EnumeratedValue < Value
    % The value used during exections. Usually initialized randomly 
    % and chagned by means of mutation.
    % Lookup Name:
    %   Value.EnumeratedValue
    
    properties
        % The following variables should be lazy initialized
        allowedValues
    end
    
    methods
        function node = EnumeratedValue(relatedEnvVar, returnType)
            if nargin < 1
                relatedEnvVar = 'unknown';
            end
            if nargin < 2
                returnType = 'unknown';
            end
            node = node@Value(relatedEnvVar, returnType);
            node.appendLookupName('EnumeratedValue');
        end
        
        function node = init(node, relatedEnvVar, allowedValues, returnType)
            % The constructor for enumerated values
            % Arguments:
            %   relatedEnvVar: The name of the environment variable
            %       related.
            %   allowedValues: The field should contain the list of
            %       allowed values. Could be empty but only in the context
            %       of the object already initialized. Otherwise, error
            %       will be thrown.
            %   returnType: The return type. Could be any type that the
            %       environment variable returns. Could be empty but 
            %       only in the context of the object already 
            %       initialized. Otherwise, an error will be thrown.
            if nargin > 1
                node.relatedEnvVar = relatedEnvVar;
                node.allowedValues = allowedValues;
                node.returnType = returnType;
            end
            
            n = length(node.allowedValues);
            if n == 0
                error("no available allowed values specified.");
            end
            idx = randi(n);
            node.value = node.allowedValues(idx);
        end
        
        function mutate(node, options, ~)
            if rand() < options.terminalMutationProb
                node.init();
            end
        end
    end
end

