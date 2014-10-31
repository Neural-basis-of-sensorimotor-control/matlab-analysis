function enable_resize_fcn(obj,enable)
if enable
    set(obj.btn_window,'ResizeFcn',@(~,~) obj.resize_btn_window());
    set(obj.plot_window,'ResizeFcn',@(~,~) obj.resize_plot_window());
else
    set(obj.btn_window,'ResizeFcn',[]);
    set(obj.plot_window,'ResizeFcn',[]);
end
end