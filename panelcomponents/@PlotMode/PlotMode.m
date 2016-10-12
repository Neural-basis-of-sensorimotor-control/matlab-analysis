classdef PlotMode < PanelComponent
  properties
    ui_plot_mode
  end
  
  methods
    function obj = PlotMode(panel)
      obj@PanelComponent(panel);
      sc_addlistener(obj.gui,'plotmode',@(~,~) obj.plotmode_listener,obj.uihandle);
      
    end
    
    function populate(obj,mgr)
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Plot mode'),100);
      [~,str_] = enumeration('PlotModes');
      obj.ui_plot_mode = mgr.add(sc_ctrl('popupmenu',str_,@(~,~) obj.plot_mode_callback),100);
    end
    
    function initialize(obj)
      [~,str_] = enumeration('PlotModes');
      val = find(enumeration('PlotModes') == obj.gui.plotmode);
      set(obj.ui_plot_mode,'string',str_,'value',val);
    end
    
  end
  
  methods (Access = 'protected')
    function plot_mode_callback(obj)
      obj.gui.lock_screen(true,'Wait, plotting...');
      str = get(obj.ui_plot_mode,'string');
      val = get(obj.ui_plot_mode,'value');
      [enum,enum_str] = enumeration('PlotModes');
      ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
      obj.gui.plotmode = enum(ind);
      obj.gui.plot_channels();
      obj.gui.lock_screen(false,'Done');
    end
    
    function plotmode_listener(obj)
      for k=1:obj.gui.plots.n
        cla(obj.gui.plots.get(k).ax);
      end
    end
  end
  
end
