function plots = get_plots(axes_handles)
%GET_PLOTS Return plot handles in axes.
%
% PLOTS = GET_PLOTS(AXES_HANDLES) Return all plot handles in AXES_HANDLES
% axes. AXES_HANDLES is a vector matrix.
%
% PLOTS = GET_PLOTS(FIGURES) Return all plot handles in figures FIGURES
% figure. FIGURES is vector matrix.
%
% PLOTS = GET_PLOTS() Return all plot handles in current axes.
%
% Hannes Mogensen, Neural Basis of Sensorimotor Control, Lund University
% 2016-07-30

if ~nargin
  plots = get_plots(gca);
  return

elseif isempty(axes_handles)
  plots = [];
  return

elseif any(arrayfun(@isfigure, axes_handles))
  
  h_axes = [];

  for i=1:length(axes_handles)
    ax = get_axes(axes_handles(i));
    h_axes = add_to_list(h_axes, ax);
  end
  
  plots = get_plots(h_axes);
  return

elseif any(arrayfun(@isaxes, axes_handles))
  
  plots = [];

  for i=1:length(axes_handles)
    p = getplots(axes_handles(i).Children);
    plots(length(plots) + (1:length(p))) = p;
  end

else
  plots = [];

  for i=1:length(axes_handles)

    if isa(axes_handles(i), 'matlab.graphics.axis.Axes')
      plots = [plots; axes_handles(i)]; %#ok<AGROW>
    end
  end
end

end

