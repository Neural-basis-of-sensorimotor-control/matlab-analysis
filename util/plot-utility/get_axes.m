function ax = get_axes(figures)
%GET_AXES Return axes handles in figure.
% AX = GET_AXES(FIGURES) Return axes handles from figure handles in vector
% matrix FIGURES
%
% AX = GET_AXES() Return axes handles for current figure
%
% Hannes Mogensen, Neural Basis of Sensorimotor Control, Lund University
% 2016-07-30

ax = [];

if ~nargin
  ax = get_axes(gcf);
  
elseif ~isempty(figures)
  
  for i=1:length(figures)
    
    children = figures(i).Children;
    
    for j=1:length(children)
      ch = children(j);
      
      if isa(ch, 'matlab.graphics.axis.Axes')
        ax = add_to_list(ax, ch);
      end
    end
  end
end