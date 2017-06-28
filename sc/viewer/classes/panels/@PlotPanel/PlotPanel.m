classdef PlotPanel < UpdatablePanel%SequenceDependentPanel
  methods (Abstract)
    setup_components(obj)
  end
  methods
    %Overriding classes must call obj.layout after calling PlotPanel
    %constructor
    function obj = PlotPanel(gui)
      panel = uipanel('Parent',gui.btn_window,'Title','Plot options');
      obj@UpdatablePanel(gui,panel);
      obj.layout();
    end

    function initialize_panel(obj)
      initialize_panel@UpdatablePanel(obj);
    end

    function update_panel(obj)
      update_panel@UpdatablePanel(obj);
      if obj.enabled    
        obj.gui.plot_channels();
      end
    end
  end

  methods

  end
end
