function add_figure_filename(ax)

if ~nargin
  ax = gca;
end

name = get(ax, 'Title');

fig = get(ax, 'Parent');

set(fig, 'FileName', [name.String '.png']);

end