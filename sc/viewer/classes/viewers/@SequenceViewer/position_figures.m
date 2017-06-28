function position_figures(obj)
obj.enable_resize_fcn(false);

screensize = get(0,'ScreenSize');

width = screensize(3)-10; height = screensize(4)-100;
setx(obj.btn_window,10); sety(obj.btn_window,45);
setheight(obj.btn_window,height);
obj.resize_btn_window();

setx(obj.plot_window,getx(obj.btn_window)+getwidth(obj.btn_window)+1); 
sety(obj.plot_window,gety(obj.btn_window));
setheight(obj.plot_window,getheight(obj.btn_window));
setwidth(obj.plot_window,width-getx(obj.plot_window));
obj.resize_plot_window();

obj.enable_resize_fcn(true);
end
