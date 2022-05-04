classdef GAModel < handle
    
    properties
        population = {}
        % A cell of individuals in the population
        
        fitnesses
        % The fitness score of every individual in the model.
        
        constructor
        % The constructor for individuals in the population.
        
        options
        % Options used for optimizing the model.
        
        status
        % A struct containing the current status of the model.
        
        statistics
        % A struct containing the model's statistics.
        
        best
        % The individual with the highest fitness score.
    end
    
    methods
        function model = GAModel(constructor)
            % Defines the type of GAMember. The variable must be the
            % constructor of a class that extends the GAMember interface.
            if ~isa(constructor(), 'GAMember')
                error('The passed in type does not implement the GAMember interface');
            end
            model.constructor = constructor;
            
            % Register default options
            model.options.verbose = 1;
            model.options.evaluateElites = false;
        end
        
        function register(model, arg1, arg2)
            % Register options one by one, or with the entire struct
            % Arguments:
            %   arg1: Provide a struct of options, or a key
            %   arg2: Only when arg1 specified the key, specify the value.
            if nargin <= 2
                fields = fieldnames(arg1);
                for i=1:length(fields)
                  model.options.(fields{i}) = arg1.(fields{i});
                end
            else
                model.options.(arg1) = arg2;
            end
        end
        
        function populate(model, populationSize)
            % Populate the GA model with populationSize of individuals.
            if nargin >= 2
                model.options.populationSize = populationSize;
            end
            model.population = cell(1, model.options.populationSize);
            for i=1:model.options.populationSize
                model.population{i} = model.constructor();
            end
        end
        
        function run(model, varargin)
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
                % Update the status struct
                model.status.generation = gen;
                
                % Evaluate the fitness of every individual
                fs = model.evaluateFitness(varargin{:});
                
                % Store the fitness scores on individuals
                for s=1:model.options.populationSize
                    model.population{s}.fitness = fs(s);
                end
                
                if model.options.verbose >= 1
                    fprintf("[Generation %d / %d] Max fitness: %s\n", ...
                        gen, gens, string(max(fs)));
                end
                
                model.reproduction(fs);
            end
            
            model.afterRun(varargin{:});
        end
        
        function beforeRun(~, varargin)
            
        end
        
        function afterRun(~, varargin)
            
        end
        
        function member = get.best(model)
            member = model.population{1};
        end
        
        function fitnesses = get.fitnesses(model)
            fitnesses = cellfun(@(x)x.fitness, model.population);
        end
    end
    
    methods(Access=protected)
        function i = select(model, fitnesses)
            % Select an individual for reproduction using the specified
            % schema. The choice of possible schemas include:
            %   1. 'roulette': Roulette wheel selection
            %   2. 'tournament': Tournament
            %       - Note: must also specify tournamentSize
            %   3. 'rank': Rank-based selection
            % The preference should be specified in the options
            % Arguments:
            %   blacklist: A list of id(s) that should not be selected
            if nargin < 2
                fitnesses = model.fitnesses();
            end
            if strcmp(model.options.selectionSchema, 'roulette') 
                % Introduce variations
                filter = randn(size(fitnesses));
                fitnesses = fitnesses + filter;

                % Shift fitnesses
                if min(fitnesses) < 0
                    fitnesses = fitnesses + abs(min(fitnesses));
                end
                
                chances = fitnesses / sum(fitnesses);
                cp = [0, reshape(cumsum(chances), 1, [])];
                
                i = find(rand() > cp, 1, 'last');
            elseif strcmp(model.options.selectionSchema, 'tournament')
                n = model.options.tournamentSize;
                group = zeros(1, model.options.tournamentSize);
                failCount = 0;
                iter = 1;
                while iter <= n
                    if failCount > 50
                        error('Maximum fail count reached.');
                    end
                    proposedI = randi([1, model.options.populationSize]);
                    if ~any(group == proposedI)
                        group(iter) = proposedI;
                        iter = iter + 1;
                    else
                        failCount = failCount + 1;
                    end
                end
                
                % The group is already sorted
                i = min(group);
            elseif strcmp(model.options.selectionSchema, 'rank')
                i = randi([1, model.options.populationSize]);
            else
                error('Unknown selection schema.');
            end
        end
        
        function reproduction(model, fs)
            % Make sure all individuals in the population are sorted
            fs = model.sortPopulation(fs);
            
            populationSize = model.options.populationSize;
            eliteEndIdx = model.options.eliteSize;
            crossoverEndIdx = eliteEndIdx + ...
                floor((populationSize - eliteEndIdx) * model.options.crossoverFraction);
            
            newPopulation = cell(1, populationSize);
            
            % Elites, directly copy from the old population
            for i=1:eliteEndIdx
                newPopulation{i} = model.population{i};
            end
            
            % For crossover
            for i=eliteEndIdx+1:crossoverEndIdx
                sela = model.select();
                selb = sela;
                a = 0;
                maxAttempts = 50;

                while selb == sela && a < maxAttempts
                    selb = model.select();
                    a = a + 1;
                end
                
                if sela == selb
                    warning('Using the same individual for crossover.');
                end

                modela = deepcopy(model.population{sela});
                modelb = model.population{selb};

                modela.crossover(modelb);
                
                if model.options.mutateAfterCrossover
                    modela.mutate(model.options);
                end
                
                newPopulation{i} = modela;
            end
            
            % Mutation
            for i=crossoverEndIdx+1:populationSize
                sleId = model.select();
                newmodel = deepcopy(model.population{sleId});
                newmodel.mutate(model.options);
                newPopulation{i} = newmodel;
            end
            
            % Replace the previous generation with the new one
            model.population = [];
            model.population = newPopulation;
        end
        
        function fitnesses = sortPopulation(model, fitnesses)
            if nargin < 2
                % Retrieve the fitness score from individuals
                fitnesses = model.fitnesses();
            end
            [fitnesses, sortIdx] = sort(fitnesses, 'descend');
            model.population = model.population(sortIdx);
        end
    end
    
    methods(Abstract)
        init(model)
        
        fitnesses = evaluateFitness(model, varargin);
        % The method should return a vector of size n, with the 
        % i-th entry being the fitness score of the i-th individual.
    end
end

