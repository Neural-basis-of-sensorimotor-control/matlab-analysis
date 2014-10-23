function resize_btn_window(obj)
x=0;
y=getheight(obj.btn_window);
min_height = max(cell2mat(obj.panels.values('height')));
if y<min_height
    setheight(obj.btn_window,min_height);
else
    for i=1:obj.panels.n
        panel = obj.panels.get(i);
        height = getheight(panel);
        if y-height<0
            x=x+obj.panel_width;
            y=getheight(obj.btn_window);
        end 
        y = y - height;
        setx(panel,x);
        sety(panel,y);
    end
end 
if getwidth(obj.btn_window)<x+obj.panel_width
    setwidth(obj.btn_window,x+obj.panel_width);
end
end