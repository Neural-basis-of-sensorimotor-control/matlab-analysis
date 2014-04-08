function height = getheight(h)
set(h,'unit','pixel');
[~,~,~,height] = get_position(h);
