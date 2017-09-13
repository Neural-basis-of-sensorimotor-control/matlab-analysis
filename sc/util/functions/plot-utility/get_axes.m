function ax = get_axes(figures)

ax = [];

if ~nargin
  
  ax = get_axes(gcf);
  
elseif ~isempty(figures)
  
  for i=1:length(figures)
    
    children = figures(i).Children;
    
    for j=1:length(children)
      
      ch = children(j);
      
      if isaxes(ch)
        ax = add_to_list(ax, ch);
      end
      
    end
    
  end
  
end
