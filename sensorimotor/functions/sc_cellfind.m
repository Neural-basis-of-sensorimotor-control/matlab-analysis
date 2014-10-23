function index = sc_cellfind(cellstr,str)
index = find(cellfun(@(x) strcmp(x,str), cellstr));
end