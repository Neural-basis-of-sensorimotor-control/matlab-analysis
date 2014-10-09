function show(obj,enable_main_panel)
if nargin<2
    enable_main_panel = 0;
end
clf(obj.btn_window,'reset');
set(obj.btn_window,'ToolBar','None');
set(obj.btn_window,'ResizeFcn',@(~,~) obj.resize_btn_window(),...
    'CloseRequestFcn',@(~,~) obj.close_request);
obj.panels = CascadeList();
obj.add_panels();
obj.panels.get(1).enabled = true;
mgr = ScLayoutManager(obj.btn_window);
for k=1:obj.panels.n
    panel = obj.panels.get(k);
    setwidth(panel,obj.panel_width);
    mgr.newline(getheight(panel));
    mgr.add(panel);
    panel.enabled_listener();
end
mgr.trim();
clf(obj.plot_window,'reset');
set(obj.plot_window,'ToolBar','None');
set(obj.plot_window,'Color',[0 0 0]);
set(obj.plot_window,'ResizeFcn',@(~,~) obj.resize_plot_window());
if obj.show_digital_channels
    obj.digital_channels.ax = axes;
end
for k=1:obj.analog_ch.n
    obj.analog_ch.get(k).ax = axes;
end
if obj.show_histogram
    obj.histogram.ax = axes;
end
if ~ishandle(obj.plot_window)
    obj.plot_window = figure;
end
mgr = ScLayoutManager(obj.plot_window);
for k=1:obj.plots.n
    plotaxes = obj.plots.get(k);
    mgr.newline(getheight(plotaxes));
    mgr.add(plotaxes);
end
%obj.sequence = obj.sequence;
for k=1:obj.panels.n
    obj.panels.get(k).initialize_panel();
end
obj.panels.get(2).enabled = enable_main_panel;
if enable_main_panel
    first_disabled = obj.panels.indexof(obj.panels.last_enabled_item);
    for k=first_disabled:obj.panels.n
        obj.panels.get(k).update_panel();
    end
end
obj.position_figures();
figure(obj.btn_window)
end