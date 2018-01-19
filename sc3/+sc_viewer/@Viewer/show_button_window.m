function show_button_window(obj)

if isempty(obj.button_window) || ~ishandle(obj.button_window)
  obj.button_window = figure;
end

set(obj.button_window, 'ToolBar', 'None', 'MenuBar', 'none');

fig_mgr = sc_layout.FigureLayoutManager(obj.button_window);

[titles, components] = sc_viewer.Viewer.get_panels();

for i=1:length(titles)
  
  panel     = uipanel('Title', titles{i});
  comp      = components{i};
  panel_mgr = sc_layout.PanelLayoutManager(panel);
  
  for j=1:2:length(comp)
    
    for k=j:j+1
      
      args   = comp(k, :);
      uictrl = sc_viewer.UiControl(obj, args{:});
    
      panel_mgr.add(uictrl.ui_object, 100);
      
    end
    
    panel_mgr.newline();
    
  end
  
  panel_mgr.trim();
  
  fig_mgr.add(panel, 200);
    
end

fig_mgr.trim();

end