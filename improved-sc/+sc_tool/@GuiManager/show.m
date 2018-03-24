function show(obj)


[titles, components] = sc_tool.GuiManager.get_panels();

fig_mgr = sc_layout.FigureLayoutManager(gcf);

for i=1:length(titles)
  
  panel     = uipanel('Title', titles{i});
  comp      = components{i};
  panel_mgr = sc_layout.PanelLayoutManager(panel);
  
  for j=1:length(comp)
    
    args   = comp{j};
    
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
  
  fig_mgr.add(panel, 2*sc_tool.UiControl.default_width);
    
end

fig_mgr.trim();

end