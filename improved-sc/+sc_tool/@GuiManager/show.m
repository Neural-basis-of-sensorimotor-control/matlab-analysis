function show(obj)

str_panels = sc_tool.GuiManager.get_panels();

fig_mgr = sc_layout.FigureLayoutManager(gcf);

for i=1:length(str_panels)
  
  tmp_components = str_panels{i};
  panel          = uipanel('Title', tmp_components{1});
  panel_mgr      = sc_layout.PanelLayoutManager(panel, 'lower_margin', 5);
  
  for j=2:length(tmp_components)
    
    args   = tmp_components{j};
    
    if isempty(args)
      
      panel_mgr.newline();
      
    else
      
      indx = 1:length(args);
      indx = find(indx == 1 | indx >= 8);
      tmp_args = args(indx);
      ui_object = sc_tool.GuiManager.create_ui_object(tmp_args{:});
      
      indx = 1:length(args);
      indx = find(indx > 1 & indx < 6);
      tmp_args = args(indx); %#ok<*FNDSB>
      sc_tool.ViewerListener(obj, ui_object, tmp_args{:});
      
      if length(args) >= 6 && ~isempty(args{6})
        setwidth(ui_object, args{6});
      end

      if length(args) >= 7 && ~isempty(args{7})
        setheight(ui_object, args{7});
      end
      
      panel_mgr.add(ui_object, getwidth(ui_object));
      
    end
    
  end
  
  panel_mgr.trim();
  
  fig_mgr.add(panel, 2*sc_tool.UiControl.default_width + 5);
  fig_mgr.newline();
    
end

fig_mgr.trim();

end