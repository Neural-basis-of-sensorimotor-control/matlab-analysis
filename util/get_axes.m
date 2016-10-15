function ax = get_axes(figures)
%GET_AXES Return axes handles in figure.
% AX = GET_AXES(FIGURES) Return axes handles from figure handles in vector
% matrix FIGURES
%
% AX = GET_AXES() Return axes handles for current figure
%
% Hannes Mogensen, Neural Basis of Sensorimotor Control, Lund University
% 2016-07-30

if ~nargin
  ax = get_axes(gcf);
  return
  
elseif isempty(figures)
  ax = [];
  
else
  ax = figures(1).Children;
  
  for i=2:length(figures)
    children = figures(1).Children;
    ax(length(ax) + (1:length(children))) = children;
  end
end