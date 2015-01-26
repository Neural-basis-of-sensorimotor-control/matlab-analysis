function enable_resize_fcn(obj,enable)
if enable
    set(obj.btn_window,'SizeChangedFcn',@(~,~) obj.resize_btn_window());
    set(obj.plot_window,'SizeChangedFcn',@(~,~) obj.resize_plot_window());
    set(obj.histogram_window,'SizeChangedFcn',@(~,~) obj.resize_histogram_window());
else
    set(obj.btn_window,'SizeChangedFcn',[]);
    set(obj.plot_window,'SizeChangedFcn',[]);
    set(obj.histogram_window,'SizeChangedFcn',[]);
end
end