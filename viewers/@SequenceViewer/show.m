function show(obj,enable_main_panel)
if nargin<2
    enable_main_panel = 0;
end
clf(obj.btn_window,'reset');
set(obj.btn_window,'ToolBar','None','MenuBar','none');
set(obj.btn_window,'CloseRequestFcn',@(~,~) obj.close_request);
obj.panels = CascadeList();
if enable_main_panel
    obj.add_panels();
else
    obj.add_main_panel();
end
obj.panels.get(1).enabled = true;
obj.panels.get(2).enabled = enable_main_panel;
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
set(obj.plot_window,'ToolBar','None','MenuBar','none');
set(obj.plot_window,'Color',[0 0 0]);

if obj.show_digital_channels
    obj.digital_channels.ax = axes;
end
for k=1:obj.analog_ch.n
    obj.analog_ch.get(k).ax = axes;
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
first_disabled = obj.panels.indexof(obj.panels.last_enabled_item);
for k=1:first_disabled-1
    panel = obj.panels.get(k);
    panel.initialize_panel();
end
for k=first_disabled:obj.panels.n
    panel = obj.panels.get(k);
    panel.initialize_panel();
    panel.update_panel();
    if ~panel.enabled
        break;
    end
end
if enable_main_panel
   % obj.position_figures();
    figure(obj.btn_window)
end
drawnow
obj.position_figures();
end