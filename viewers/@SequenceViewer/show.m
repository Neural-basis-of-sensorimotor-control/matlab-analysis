function show(obj)
if ishandle(obj.current_view)
    clf(obj.current_view,'reset');
else
    obj.current_view = gcf;
end
set(obj.current_view,'ToolBar','None');
set(obj.current_view,'Color',[0 0 0]);
obj.panels = CascadeList();
obj.add_panels();
obj.panels.get(1).enabled = true;
mgr = ScLayoutManager(obj.current_view);
for k=1:obj.panels.n
    panel = obj.panels.get(k);
    setwidth(panel,obj.panel_width);
    mgr.newline(getheight(panel));
    mgr.add(panel);
    panel.enabled_listener();
end
mgr.trim();
if obj.show_digital_channels
    obj.digital_channels.ax = axes;
end
for k=1:obj.analog_ch.n
    obj.analog_ch.get(k).ax = axes; 
end
if obj.show_histogram
    obj.histogram.ax = axes;
end
mgr = ScLayoutManager(obj.current_view);
for k=1:obj.plots.n
    plotaxes = obj.plots.get(k);
    mgr.newline(getheight(plotaxes));
    mgr.add(plotaxes);
end

obj.sequence = obj.sequence;
for k=1:obj.panels.n
    obj.panels.get(k).initialize_panel();
end
set(obj.current_view,'ResizeFcn',@(~,~) obj.resize_figure());
obj.resize_figure();
end