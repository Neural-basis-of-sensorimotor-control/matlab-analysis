function index  = sc_find(itemset,item)
index = find(cellfun(@(x) x==item, itemset));
end