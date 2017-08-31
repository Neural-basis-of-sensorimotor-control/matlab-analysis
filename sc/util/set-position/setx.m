function setx(h, x, varargin)

[~, y_, width_, height_] = get_position(h, varargin{:});

set_position(h,x, y_, width_, height_, varargin{:});

 end
