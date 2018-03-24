function callback_yzoom_in(obj, ~, ~)

yl = ylim(obj.signal1_axes);

ydiff = diff(yl);
yl(1) = yl(1) + ydiff/4;
yl(2) = yl(2) - ydiff/4;

ylim(obj.signal1_axes, yl);
        
end