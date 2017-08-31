function setwidth(h, width, varargin)

[x, y, ~, height] = get_position(h, varargin{:});

set_position(h, x, y, width, height, varargin{:});

end
