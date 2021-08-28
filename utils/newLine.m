function newLine(level)
% Generate identation for new lines
% Arguments:
%   level: the indentation level. Default value: 1.
%       If set to 0, no new line will be created.
if level ~= 0
    fprintf("\n");
    for i=1:level-1
        fprintf("  ");
    end
end
end

