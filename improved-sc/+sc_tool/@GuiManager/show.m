function show(obj)

fig_mgr = sc_layout.FigureLayoutManager(obj.button_window);

[titles, components] = sc_tool.GuiManager.get_panels();

for i=1:length(titles)
  
  panel     = uipanel('Title', titles{i});
  comp      = components{i};
  panel_mgr = sc_layout.PanelLayoutManager(panel);
  
  for j=1:2:size(comp, 1)
    
    for k=j:j+1
      
      args   = comp(k, :);
      uictrl = sc_tool.UiControl(obj, args{:});
    
      panel_mgr.add(uictrl.ui_object, 100);
      
    end
    
    panel_mgr.newline();
    
  end
  
  panel_mgr.trim();
  
  fig_mgr.add(panel, 200);
    
end

fig_mgr.trim();

end