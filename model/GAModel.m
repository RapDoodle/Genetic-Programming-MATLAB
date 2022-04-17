classdef GAModel < handle
    
    properties
        populationSize
        population = {}
        fitnesses
        constructor
        verbose = 1
        options
        status
        statistics
    end
    
    methods
        function model = GAModel(constructor)
            % Define the type of GAMember. The variable must be the
            % constructor of a class that extends the GAMember interface.
            if ~isa(constructor(), 'GAMember')
                error('The passed in type does not implement the GAMember interface');
            end
            model.constructor = constructor;
        end
        
        function populate(model, populationSize)
            % Populate the GA model with populationSize of individuals
            model.populationSize = populationSize;
            for i=1:populationSize
                model.population{i} = model.constructor();
            end
        end
        
        function set.verbose(model, verbose)
            % Set the verbose level.
            % Arguments:
            %   verbose: The verbose level
            %       0: Mute
            %       1: Only show results for each generation
            %       2: Show information for each generation
            %       3: Show results for individual
            %       4: Show information for each individual (default)
            if (verbose < 0 || verbose > 4)
                error('Invalid verbose level.');
            end
            model.verbose = verbose;
        end
        
        function set.options(model, options)
            % Set the options for optimizing the GA model.
            % Arguments:
            %   
            if ~isa(options, 'struct')
                error('Invalid options. The options must be stored in a struct.');
            end
            model.options = options;
        end
        
        function stat = run(model, varargin)
            % Start optimizing with genetic algorithm on the model.
            % Arguments:
            %   func: The function used to evaluate the fitness
            %   data: The data to be provided to the function
            %   generations: The number of generations
            %   options: A struct of options
            model.beforeRun(varargin{:});
            
            gens = model.options.generations;
            model.status.generations = gens;
            
            % Statistics
            model.statistics.minFitnesses = zeros(gens, 1);
            model.statistics.maxFitnesses = zeros(gens, 1);
            for gen=1:gens
                if model.verbose >= 2
                    fprintf("Running generation %d / %d\n", gen, gens);
                end
                model.forEachGeneration(gen, gens, varargin{:});
            end
            
            model.afterRun(varargin{:});
        end
        
        function summary(model, index)
            if nargin < 2
                index = 1;
            end
            
            n = length(model.population{index}.tradingCommittee.members);
            for i=1:n
                fprintf("\nFUNCTION AGENT" + string(i) + "()");
                model.population{1}.tradingCommittee.population{i}.rootNode.summary(2)
                fprintf("\nEND\n");
            end
        end
        
        function fitnesses = sortPopulation(model, fitnesses)
            if nargin < 2
                fitnesses = model.fitnesses;
            end
            [fitnesses, sortIdx] = sort(fitnesses, 'descend');
            model.population = model.population(sortIdx);
        end
    end
    
    methods(Access=protected)
        function naturalSelection(model)
            % Natural selection
            keepIdx = int32(model.populationSize * model.options.keepRate);
            model.population = {model.population{1:keepIdx}};
        end
        
        function reproduction(model, fitnesses)
            if nargin < 2
                fitnesses = model.fitnesses;
            end
            
            n = length(model.population);
            fitnesses = fitnesses(1:n);
            assert(n < model.populationSize, 'The population is full.');
            
            % Introduce variations
            filter = randn(size(fitnesses));
            fitnesses = fitnesses + filter;
            
            % Shift fitnesses
            if min(fitnesses) < 0
                fitnesses = fitnesses + abs(min(fitnesses));
            end
            
            chances = fitnesses / sum(fitnesses);
            cp = [0, reshape(cumsum(chances), 1, [])];
            
            % Reproduction
            for i = n+1:model.populationSize
                sela = find(rand() > cp, 1, 'last');

                selb = sela;

                selected = false;
                a = 0;
                maxAttempts = 50;

                while a < maxAttempts
                    selb = find(rand() > cp, 1, 'last');
                    a = a + 1;

                    if selb ~= sela
                        selected = true;
                        break;
                    end
                end

                if ~selected
                    % Major cause: the first individual dominates the
                    %   landscape, accounting for more than 99% of the
                    %   chances. The rest performs very similarly.
                    %   Hence, doing random selection is fine.
                    warning("Using linear selection.");
                    while selb == sela
                        selb = randi([1, keepIdx]);
                    end
                end

                modela = deepcopy(model.population{sela});
                modelb = model.population{selb};

                modela.crossover(modelb);
                modela.mutate(model.options);

                model.population{i} = modela;
            end
        end
    end
    
    methods(Abstract)
        init(model)
        beforeRun(model, varargin)
        forEachGeneration(model, gen, gens, varargin)
        afterRun(model, varargin)
    end
end

