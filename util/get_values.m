function val = get_values(list, property)

if iscell(list)
  val = cellfun(@(x) x.(property), list, 'UniformOutput', true);
else
  val = {list.(property)};
end

end