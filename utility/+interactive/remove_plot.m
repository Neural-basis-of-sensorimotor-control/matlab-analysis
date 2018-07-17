function remove_plot(h_fig)

if ~nargin
  h_fig = gcf;
end

h_plots = get_plots(h_fig);
arrayfun(@(x) set(x, 'ButtonDownFcn', @(src, ~) delete(src), 'HitTest', 'on'), h_plots);

end