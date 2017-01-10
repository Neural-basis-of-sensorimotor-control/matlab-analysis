function ind = sc_str_find(cell_array_str, str, k)

if iscell(str) && length(str) > 1
  ind = nan(length(str), k);
  for i=1:length(str)
    ind(i, :) = sc_str_find(cell_array_str, str{i}, k);
  end
else
  ind = cellfun(@(x) strcmp(x, str), cell_array_str);

  if exist('k', 'var')
    ind = find(ind);
    k = min(k, length(ind));
    ind = ind(1:k);
  end
end

end