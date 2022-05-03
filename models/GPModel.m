classdef GPModel < GAModel
    methods
        function model = GPModel(constructor)
            % Define the type of GPMember. The variable must be the
            % constructor of a class that extends the GPMember interface.
            if ~isa(constructor(), 'GPMember')
                error('The passed in type does not implement the GAMember interface');
            end
            model = model@GAModel(constructor);
        end
        
        function init(model, template, maxHeight)
            for i=1:model.populationSize
                model.population{i}.init(template, maxHeight);
            end
        end
        
        function pseudocode(model, index)
            if nargin < 2
                index = 1;
            end
            model.population{index}.rootNode.summary(1);
        end
    end
end

