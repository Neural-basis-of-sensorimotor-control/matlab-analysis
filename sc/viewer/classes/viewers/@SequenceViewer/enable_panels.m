function enable_panels(obj,panel)
index = obj.panels.indexof(panel);
for k=index:obj.panels.n
  %  obj.panels.get(k).update_panel();
    obj.panels.get(k).initialize_panel();
    if ~obj.panels.get(k).enabled
      break;
    end
  end
  end
