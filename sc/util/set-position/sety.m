function sety(h, y, varargin)

[x_, ~, width_, height_] = get_position(h, varargin{:});

set_position(h, x_, y, width_, height_, varargin{:});

end
