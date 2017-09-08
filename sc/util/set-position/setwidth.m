function setwidth(h, width)

[x, y, ~, height] = get_position(h);

set_position(h, x, y, width, height);

end
