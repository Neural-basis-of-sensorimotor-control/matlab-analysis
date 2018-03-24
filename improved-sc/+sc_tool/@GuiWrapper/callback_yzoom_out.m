function callback_yzoom_out(obj, ~, ~ )

yl = ylim(obj.signal1_axes);
ydiff   = diff(yl);
yl = yl + [-ydiff/2 ydiff/2];
ylim(obj.signal1_axes, yl);

end