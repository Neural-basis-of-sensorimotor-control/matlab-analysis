function [x, y, width, height] = get_position(h, unit)

if nargin < 2
  unit = 'pixel';
end

set(h, 'unit', unit);

position = get(h,'position');

x       = position(1);
y       = position(2);
width   = position(3);
height  = position(4);

end
