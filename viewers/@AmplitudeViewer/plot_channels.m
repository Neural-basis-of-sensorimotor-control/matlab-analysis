function plot_channels(obj)
for k=1:obj.plots.n
    if obj.plots.get(k).ax == obj.main_axes
        obj.plots.get(k).plotch(@(~,~) obj.btn_down_plot);
        
        set(obj.main_axes,'ButtonDownFcn',@(~,~) obj.btn_down_axes);
    else
        obj.plots.get(k).plotch();
    end
end
end