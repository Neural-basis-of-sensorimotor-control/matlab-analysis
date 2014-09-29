function set_position(h,x, y, width, height)
if strcmp(get(h,'Type'),'axes')
    set(h,'ActivePositionProperty','outerposition');
    set(h,'outerposition',[x y width height]);
else
    set(h,'position',[x y width height]);
end
end