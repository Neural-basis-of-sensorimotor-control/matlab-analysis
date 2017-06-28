function index  = sc_find(itemset,item)
if isnumeric(item)
  index = find(cellfun(@(x) x==item, itemset));
elseif ischar(item)
  index = find(cellfun(@(x) strcmpi(x,item), itemset));
end
end
