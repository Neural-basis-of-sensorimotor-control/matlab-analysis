classdef HelpBox < PanelComponent
  properties
    ui_text
  end
  methods
    function obj = HelpBox(panel)
      obj@PanelComponent(panel);
      sc_addlistener(obj.gui,'help_text',@(~,~) obj.initialize,obj.uihandle);
    end
    function populate(obj,mgr)
      mgr.newline(40);
      obj.ui_text = mgr.add(sc_ctrl('text',[],[],'Value',2),200);
    end
    function initialize(obj)
      set(obj.ui_text,'string',obj.gui.help_text);
    end
  end
  
  methods (Access='protected')
  end
end
