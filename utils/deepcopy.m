function newObj = copy(obj)
% Create a deep copy of any object provided
newObj = getArrayFromByteStream(getByteStreamFromArray(obj));
end

