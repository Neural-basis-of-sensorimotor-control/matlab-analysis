function val = get_values(list, property)

if isa(list, 'cell')
  val = cellfun(@(x) x.(property), list, 'UniformOutput', false);
else
  val = cell2mat({list.(property)});
end

end