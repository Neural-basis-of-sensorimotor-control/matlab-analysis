function set_titles(fig, varargin)

ax = get_axes(fig);

for i=1:length(ax)
  axes(ax(i));
  title(varargin{i});
end


end