function setheight(h, height, varargin)

[x, y, width] = get_position(h, varargin{:});

set_position(h, x, y, width, height, varargin{:});

end
