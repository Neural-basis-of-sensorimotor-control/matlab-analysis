classdef ScUserInfoPanel < ScGuiComponent
  
  properties
    ui_user_info
  end
  
  methods (Static)
    
    function panel = get_panel(viewer)
      
      info_panel = ScUserInfoPanel(viewer);
      panel      = uipanel(info_panel.viewer.btn_window, 'Title', 'User info');
      mgr        = ScLayoutManager(panel);
      h          = sc_ctrl('text', info_panel.viewer.user_info);
      
      setheight(h, 400);
      mgr.add(h, 200);
      mgr.trim();
      
      sc_addlistener(h.viewer, 'user_info', @(~,~) info_panel.user_info_callback, ...
        panel);
      
    end
    
  end
  
  methods
    
    function obj = ScUserInfoPanel(viewer)
      obj@ScGuiComponent(viewer);
    end
    
  end
  
  methods (Access = 'private')
    
    function user_info_callback(obj)
      
      set(obj.ui_user_info, 'String', obj.viewer.user_info);
      
    end
    
  end
  
end