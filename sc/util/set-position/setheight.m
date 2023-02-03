function setheight(h, height)

if height<0
    warning('height < 0')
    return
end

[x, y, width] = get_position(h);

set_position(h, x, y, width, height);

end
