function resize_plot_window(obj)
y = getheight(obj.plot_window);
axeswidth = getwidth(obj.plot_window)- 3*obj.margin - getx(obj.plot_window);
for i=1:obj.plots.n
    ax_ = obj.plots.get(i);
    if i==1
        y = y - (getheight(ax_) + 10);
    else
        y = y - (getheight(ax_) + obj.margin);
    end
    sety(ax_,y);
    if axeswidth>0,    setwidth(ax_,axeswidth);   end
    setx(ax_, 2*obj.margin);
end
end