classdef GAMember < handle
    properties
        fitness
        % The fitness score of the individual. The default behavior of the 
        % GAModels does NOT depend on this property. This property is only 
        % for convenient statistics retrieval.
    end
    
    methods(Abstract)
        % Genetic operators
        
        crossover(member, mateMember, opt)
        % Crossover operation in GA.
        
        mutate(member, opt)
        % Mutation in GA.
    end
end

