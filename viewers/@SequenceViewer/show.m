function show(obj,enable_main_panel)
obj.dbg_in(mfilename,'SequenceViewer','show','1');obj.dbg_out();
if nargin<2
    obj.dbg_in(mfilename,'SequenceViewer','show','2');obj.dbg_out();
    enable_main_panel = 0;
end
if ishandle(obj.current_view) %&& ~enable_main_panel
    obj.dbg_in(mfilename,'SequenceViewer','show','3');obj.dbg_out();
    clf(obj.current_view,'reset');
else
    obj.dbg_in(mfilename,'SequenceViewer','show','4');obj.dbg_out();
    obj.current_view = gcf;
end
obj.dbg_in(mfilename,'SequenceViewer','show','5');obj.dbg_out();
set(obj.current_view,'ToolBar','None');
set(obj.current_view,'Color',[0 0 0]);
%if ~enable_main_panel
    obj.dbg_in(mfilename,'SequenceViewer','show','6');obj.dbg_out();
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
%end
obj.dbg_in(mfilename,'SequenceViewer','show','7');obj.dbg_out();
obj.sequence = obj.sequence;
for k=1:obj.panels.n
    obj.dbg_in(mfilename,'SequenceViewer','show','8',k);obj.dbg_out();
    obj.panels.get(k).initialize_panel();
end
obj.dbg_in(mfilename,'SequenceViewer','show','9');obj.dbg_out();
obj.panels.get(2).enabled = enable_main_panel;
first_disabled = obj.panels.indexof(obj.panels.last_enabled_item);
for k=first_disabled:obj.panels.n
    obj.dbg_in(mfilename,'SequenceViewer','show','10',k);obj.dbg_out();
    obj.panels.get(k).update_panel();
end
set(obj.current_view,'ResizeFcn',@(~,~) obj.resize_figure(),...
    'CloseRequestFcn',@(src,evt) sc_close_request(src,evt,obj));
obj.resize_figure();
obj.dbg_in(mfilename,'SequenceViewer','show','11');obj.dbg_out();
end