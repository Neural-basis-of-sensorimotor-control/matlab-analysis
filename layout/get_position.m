function [x, y, width, height] = get_position(h)
set(h,'unit','pixel');
% if strcmp(get(h,'Type'),'axes')
%     set(h,'ActivePositionProperty','outerposition');
%     position = get(h,'outerposition');
% else
    position = get(h,'position');
%end
x = position(1);        y = position(2);
width = position(3);    height = position(4);
end