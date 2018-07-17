function remove_tag(h_fig)

if ~nargin
  h_fig = gcf;
end

h_plots = get_plots(h_fig);
arrayfun(@(x) set(x, 'ButtonDownFcn', @(src, ~) delete_tag(src), 'HitTest', 'on'), h_plots);

end


function delete_tag(src)

h_fig = src.Parent.Parent;
h_plots = get_plots(h_fig);
h_plots = h_plots(arrayfun(@(x) strcmp(x.Tag, src.Tag), h_plots));
for i=1:length(h_plots)
  delete(h_plots(i));
end
arrayfun(@delete, h_plots);

end