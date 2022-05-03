classdef GPMember < GAMember
    % Implementes the GAMember interface.
    
    properties
        rootNode
        % The root of the genetic program's parse tree. Handled  
        % internally by the framework.
        
        template
        % The template that defines how the tree is grown. Handled 
        % internally by the framework.
        
        maxHeight
        % The maximum height allowed for the parse tree
    end
    
    methods
        function member = GPMember()
            
        end
        
        function init(member, template, maxHeight)
            member.template = template;
            member.maxHeight = maxHeight;
            member.rootNode = member.template.getNode({'Root'}, "", maxHeight);
            member.rootNode.setTemplate(member.template);
            member.rootNode.grow(member.maxHeight);
        end
        
        function signal = exec(member, env)
            % Execute the strategy.
            % Arguments:
            %   env: A struct containing the values of the environment 
            %        variables.
            signal = member.rootNode.exec(env);
        end
        
        function crossover(member, mateMember)
            % Crossover operation in GP.
            member.rootNode.crossover(mateMember.rootNode);
        end
        
        function mutate(member, opt)
            % Mutation in GP.
            member.rootNode.mutate(opt);
        end
        
        function depth = getDepth(member)
            % Get the depth of the parse tree.
            depth = member.rootNode.getDepth();
        end
    end
end

