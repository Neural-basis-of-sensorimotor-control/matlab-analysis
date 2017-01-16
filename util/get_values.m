function val = get_values(list, property)

if isfunction(property)
  
  if iscell(list)
    val = cellfun(property, list, 'UniformOutput', false);
  else
    val = arrayfun(property, list, 'UniformOutput', false);
  end
  
else
  
  if iscell(list)
    val = cellfun(@(x) x.(property), list, 'UniformOutput', false);
  else
    val = {list.(property)};
  end
  
end

if size(list,1) ~= size(val,1)
  val = val';
end

end