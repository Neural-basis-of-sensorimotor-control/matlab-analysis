function val =  match(obj, str)

if ischar(str)
  str = {str};
end

ind = false(size(obj.list));

for i=1:length(str)
  ind = ind | cellfun(@(x) strcmp(x, str{i}), {obj.list.tag});
end

val = obj.list(ind);