function change_font()

import sc_plot_util.*

f = get_all_figures();
font = 'Arial';

for i=1:length(f)
  %helper_change_font(f(i), 'Arial');
  
  graphicsobjects = findall(f(i), '-depth', inf, '-property', 'FontName');
  
  for j=1:length(graphicsobjects)
    
    tmp_graphicsobject = graphicsobjects(j);
    
    if any(cellfun(@(x) strcmp(x, 'FontName'), properties(tmp_graphicsobject)))
      set(tmp_graphicsobject, 'FontName', font);
    end
    
  end
  
end

end


function helper_change_font(graphicsobject, font)

if any(cellfun(@(x) strcmp(x, 'FontName'), properties(graphicsobject)))
  set(graphicsobject, 'FontName', font);
end

if any(cellfun(@(x) strcmp(x, 'Children'), properties(graphicsobject)))
  
  children = get(graphicsobject, 'Children');
  
  for i=1:length(children)
    helper_change_font(children(i), font);
  end
  
end

end