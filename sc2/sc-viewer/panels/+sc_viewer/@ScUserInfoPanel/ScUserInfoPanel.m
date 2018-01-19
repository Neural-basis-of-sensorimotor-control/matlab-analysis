classdef ScUserInfoPanel < sc_viewer.ScViewerComponent
  
  properties
    ui_user_info
  end
  
  methods (Static)
    
    function panel = get_panel(viewer)
      
      panel            = uipanel(viewer.button_window, 'Title', 'User info');
      info_panel       = sc_viewer.ScUserInfoPanel(panel, viewer);
      mgr              = sc_layout.PanelLayoutManager(panel);
      mgr.add(sc_ctrl('text', info_panel.viewer.user_info), 200);
      mgr.trim();
      
      sc_addlistener(info_panel.viewer, 'user_info', @(~,~) info_panel.user_info_callback(), ...
        panel);
      
    end
    
  end
  
  methods
    
    function obj = ScUserInfoPanel(panel, viewer)
      obj@sc_viewer.ScViewerComponent(panel, viewer);
    end
    
  end
  
  methods (Access = 'private')
    
    function user_info_callback(obj)
      
      set(obj.ui_user_info, 'String', obj.viewer.user_info);
      
    end
    
  end
  
end