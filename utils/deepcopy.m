function newObj = deepcopy(obj)
% Create a deep copy of any object provided
newObj = getArrayFromByteStream(getByteStreamFromArray(obj));
end

