function resize_figure(obj)
obj.dbg_in(mfilename,'resize_figure');
y = getheight(obj.current_view);
obj.dbg_in(mfilename,'resize_figure');
for i=1:obj.panels.n
    obj.dbg_in(mfilename,'resize_figure');
    y = y - getheight(obj.panels.get(i));
    obj.dbg_in(mfilename,'resize_figure');
    sety(obj.panels.get(i),y);
    obj.dbg_out(mfilename,'resize_figure');
    obj.dbg_out(mfilename,'resize_figure');
end
obj.dbg_out(mfilename,'resize_figure');
y = getheight(obj.current_view);
axeswidth = getwidth(obj.current_view)- (obj.panel_width + 3*obj.margin);
for i=1:obj.plots.n
    ax_ = obj.plots.get(i);
    if i==1
        y = y - (getheight(ax_) + 10);
    else
        y = y - (getheight(ax_) + obj.margin);
    end
    sety(ax_,y);
    if axeswidth>0,    setwidth(ax_,axeswidth);   end
    setx(ax_, obj.panel_width + 2*obj.margin);
end
obj.dbg_out(mfilename,'resize_figure');
end