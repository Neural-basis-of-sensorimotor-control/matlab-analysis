classdef ResetButton < PanelComponent
  %Reset GUI
  properties
    ui_reset
  end
  methods
    function obj = ResetButton(panel)
      obj@PanelComponent(panel);
    end

    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_reset = mgr.add(sc_ctrl('pushbutton','Re-enable buttons',@(~,~) obj.reset_callback),200);
      obj.gui.reset_btn = obj.ui_reset;
    end
  end

  methods (Access = 'protected')

    function reset_callback(obj)    
      obj.gui.lock_screen(false);
    end

  end
end
