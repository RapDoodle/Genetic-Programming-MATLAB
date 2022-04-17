classdef GPMember < GAMember
    % Implementes the GPMember interface.
    
    properties
        rootNode
        template
        maxHeight
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
            signal = member.rootNode.exec(env);
        end
        
        function crossover(member, mateMember)
            member.rootNode.crossover(mateMember.rootNode);
        end
        
        function mutate(member, opt)
            member.rootNode.mutate(opt);
        end
        
        function depth = getDepth(member)
            depth = member.rootNode.getDepth();
        end
    end
end

