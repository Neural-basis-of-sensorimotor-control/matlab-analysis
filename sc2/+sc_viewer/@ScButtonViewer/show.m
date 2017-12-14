function show(obj)

error('Not implemented yet');

%Clear all figures
set(obj.btn_window,  'ToolBar','None','MenuBar','none');
set(obj.btn_window,  'CloseRequestFcn',@(~,~) obj.close_request);
clf(obj.plot_window, 'reset');
set(obj.plot_window, 'Tag', ScViewer.figure_tag)

mgr = ColumnLayoutManager(obj.btn_window);
mgr.add(ScUserInfoPanel(obj));

end