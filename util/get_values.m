function val = get_values(list, property)

if iscell(list)
  val = cellfun(@(x) x.(property), list, 'UniformOutput', false);
else
  val = {list.(property)};
end

end