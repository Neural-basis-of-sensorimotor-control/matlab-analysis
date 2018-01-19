function show(obj)

%Clear all figures
if isempty(obj.button_window) || ~ishandle(obj.button_window)
  obj.button_window = figure;
end

set(obj.button_window, 'ToolBar', 'None', 'MenuBar', 'none');
set(obj.button_window, 'CloseRequestFcn', @(~,~) obj.close_request);
set(obj.button_window,  'Tag',            sc_viewer.ScViewer.figure_tag)

if isempty(obj.plot_window) || ~ishandle(obj.plot_window)
  obj.plot_window = figure;
end

clf(obj.plot_window,   'reset');
set(obj.plot_window,   'Tag', sc_viewer.ScViewer.figure_tag)

mgr = sc_layout.FigureLayoutManager(obj.button_window);
mgr.add(sc_viewer.ScUserInfoPanel.get_panel(obj), 200);
mgr.newline();
mgr.add(sc_viewer.ScExperimentPanel.get_panel(obj), 200);
%mgr.newline();
%mgr.add(sc_viewer.ScTriggerPanel.get_panel(obj));

mgr.trim();

end