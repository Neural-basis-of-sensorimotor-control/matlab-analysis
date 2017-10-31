function change_property(property, value)

f = get_all_figures();

for i=1:length(f)
  
  graphicsobjects = findall(f(i), '-depth', inf, '-property', property);
  
  for j=1:length(graphicsobjects)
    
    tmp_graphicsobject = graphicsobjects(j);
    
    if any(cellfun(@(x) strcmp(x, property), properties(tmp_graphicsobject)))
      set(tmp_graphicsobject, property, value);
    end
    
  end
  
end

end