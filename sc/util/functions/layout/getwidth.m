function width = getwidth(h)
set(h,'unit','pixel');
[~,~,width] = get_position(h);
