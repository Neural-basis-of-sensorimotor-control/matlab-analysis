function plots = sc_get_plots(ax)
if ~nargin, ax = gca; end
if length(ax) > 1
  plots = [];
  for i=1:length(ax)
    plots = [plots; sc_get_plots(ax(i))]; %#ok<AGROW>
  end
else
  if isa(ax, 'matlab.ui.Figure')
    ax_ = ax.Children;
    plots = [];
    for i=length(ax_):-1:1
      plots = [plots; sc_get_plots(ax_(i))]; %#ok<AGROW>
    end
  elseif strcmp(ax.Type, 'axes')
    plots = ax.Children;
    for i=length(plots):-1:1
      if ~isa(plots(i), 'matlab.graphics.chart.primitive.Line')
        plots(i) = [];
      end
    end
  else
    plots = [];
    %error('Unknown type of input: %s', ax.Type)
  end
end