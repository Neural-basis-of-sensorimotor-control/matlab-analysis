classdef AbsoluteTime < PanelComponent
  properties
    ui_abstime
  end
  methods
    function obj = AbsoluteTime(panel)
      obj@PanelComponent(panel);
      sc_addlistener(obj.gui,'sweep',@(~,~) obj.sweep_listener(),obj.uihandle);
    end
    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_abstime = mgr.add(sc_ctrl('text',[]),200);
    end
    function initialize(obj)
      obj.sweep_listener();
    end
    function updated = update(obj)
      obj.sweep_listener();
      updated = update@PanelComponent(obj);
    end
  end
  methods (Access=protected)
    function sweep_listener(obj)
      if numel(obj.gui.triggertimes) && numel(obj.gui.sweep) && obj.gui.sweep(1)<=numel(obj.gui.triggertimes)
        time = obj.gui.triggertimes(obj.gui.sweep(1));
        set(obj.ui_abstime,'string',sprintf('t = 0 => %g s',time));
      else
        set(obj.ui_abstime,'string','t = 0 => NA');
      end 
    end
  end
end
