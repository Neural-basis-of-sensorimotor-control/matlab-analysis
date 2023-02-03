function setwidth(h, width)

if width<0
    warning('width < 0')
    return
end

[x, y, ~, height] = get_position(h);

set_position(h, x, y, width, height);

end
