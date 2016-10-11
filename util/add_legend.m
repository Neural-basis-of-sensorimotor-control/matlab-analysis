function h = add_legend(plot_handles)
%ADD_LEGEND Add legend to plot axes, using the value of the Tag property 
%for each plot handle in the axes. Also adjust the LineColor property so
%that all plots with the same Tag value have the same color.
%
% ADD_LEGEND(PLOTS) Add a legend to plot axes with the labels given by the
% Tag property values of the plot handles in vector matrix PLOTS. The
% LineColor property is also changed to be consistent for all plots with
% each Tag property value. 
%
% If the plots are from more than one parent axes,
% the legend will be added to all parent axes. Plots with an empty Tag
% property value will be given a separate color, but they will not be added
% to the legend.
%
% Function assumes all plot handles to have the same LineStyle, LineWidth
% etc.
% 
% ADD_LEGEND(AX) Add legend to all axes in vector matrix AX.
%
% ADD_LEGEND(FIGURES) Add legend to all axes handles that are children to
% figures in vector matrix FIGURES.
%
% ADD_LEGEND() Add legend to current axes.
%
% H = ADD_LEGEND(...) returns a handle to the legend.
%
% Hannes Mogensen, Neural Basis of Sensorimotor Control, Lund University
% 2016-07-30

if ~nargin
  if nargout
    h = add_legend(gca);
  else
    add_legend(gca);
  end
  return
  
elseif isempty(plot_handles)
  if nargout, h = []; end
  return
  
elseif isa(plot_handles(1), 'matlab.ui.Figure')
  if nargout
    h = add_legend(get_plots(plot_handles));
  else
    add_legend(get_plots(plot_handles));
  end
  
  return
  
elseif isa(plot_handles(1), 'matlab.graphics.axis.Axes')
  if nargout
    h = add_legend(get_plots(plot_handles));
  else
    add_legend(get_plots(plot_handles));
  end
  
  return
  
elseif ~isa(plot_handles(1), 'matlab.graphics.chart.primitive.Line')
  error('Function not defined for input class ''%s''', ...
    class(plot_handles(1)));
end

tags = {plot_handles.Tag};
unique_tags = unique(tags);

colors = varycolor(length(unique_tags));

ax_handles = {plot_handles.Parent};
unique_ax_handles = ax_handles{1};

for i=2:length(ax_handles)
  if ~any(unique_ax_handles == ax_handles{i})
    unique_ax_handles = [unique_ax_handles; ax_handles{i}]; %#ok<AGROW>
  end
end

for i=1:length(plot_handles)
  indx = find(cellfun(@(x) strcmp(x, tags{i}), unique_tags), 1);
  plot_handles(i).Color = colors(indx, :);
end

empty_tag_indx = cellfun(@isempty, unique_tags);
unique_tags(empty_tag_indx) = [];

if isempty(unique_tags)
  return;
end

sample_plots(length(unique_tags)) = plot_handles(end);
for i=1:length(unique_tags)
  indx = find(cellfun(@(x) strcmp(x, unique_tags{i}), tags), 1);
  sample_plots(i) = plot_handles(indx);
end

for i=1:length(unique_ax_handles)
  if nargout
    h(i) = legend(unique_ax_handles(i), sample_plots, unique_tags{:}); %#ok<AGROW>
  else
    legend(unique_ax_handles(i), sample_plots, unique_tags{:});
  end
end
