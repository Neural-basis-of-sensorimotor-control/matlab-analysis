function [x, y, width, height] = get_position(h)

set(h, 'Units', 'pixels');
position  = get(h, 'Position');

x         = position(1);
y         = position(2);
width     = position(3);
height    = position(4);

end
