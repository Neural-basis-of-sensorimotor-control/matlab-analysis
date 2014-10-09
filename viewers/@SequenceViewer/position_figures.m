function position_figures(obj)
screensize = get(0,'ScreenSize');
width = screensize(3)-10; height = screensize(4)-100;
setx(obj.btn_window,10); sety(obj.btn_window,45);
setheight(obj.btn_window,height);
setx(obj.plot_window,getx(obj.btn_window)+getwidth(obj.btn_window)+1); sety(obj.plot_window,gety(obj.btn_window));
setheight(obj.plot_window,getheight(obj.btn_window)), setwidth(obj.plot_window,width);
end