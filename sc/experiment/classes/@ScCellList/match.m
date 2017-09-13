function val =  match(obj, str)

if ischar(str)
  str = {str};
end

ind = false(size(obj.list));

for i=1:length(str)
  ind = ind | cellfun(@(x) strcmp(x, str{i}), obj.values('tag'));
end

val = obj.cell_list(ind);

end