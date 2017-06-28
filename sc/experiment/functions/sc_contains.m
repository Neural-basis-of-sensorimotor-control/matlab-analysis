function found = sc_contains(cellstr,str)
found = ~isempty(find(cellfun(@(x) strcmp(x,str), cellstr),1));
end
