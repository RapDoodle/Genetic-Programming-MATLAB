classdef GPMember < handle
    properties
        fitness
    end
    methods(Abstract)
        % Execute the internal logic of the member
        output = exec(member, env)
        
        % Genetic operators in GP
        crossover(member, mateMember, opt)
        mutate(member, opt)
    end
end

