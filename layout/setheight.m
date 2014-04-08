function setheight(h,height)
[x, y, width] = get_position(h);
set_position(h,x,y,width,height);
end