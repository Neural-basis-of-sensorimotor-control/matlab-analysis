function set_position(h, x, y, width, height, unit)

if nargin < 6
  unit = 'pixel';
end

set(h, 'unit', unit, 'position', [x y width height]);

end
