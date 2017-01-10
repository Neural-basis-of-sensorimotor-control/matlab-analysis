function val = invert_colormap(cmap, varargin)

val = cmap(varargin{:});
val = val(size(val,1):-1:1, :);

end