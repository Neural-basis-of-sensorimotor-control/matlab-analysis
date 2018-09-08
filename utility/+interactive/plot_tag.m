function plot_tag(h_fig)

if ~nargin
  h_fig = gcf;
end

h_plots = get_plots(h_fig);
arrayfun(@(x) set(x, 'ButtonDownFcn', @(src, ~) disp(x.Tag), 'HitTest', 'on'), h_plots);

end