classdef GuiComponent < UiWrapper
  %Object that references a Viewer class
  properties
    gui
  end
  properties (Dependent)
    sweep
    triggertimes
    histogram_window
    experiment
    file
    sequence
  end
  methods
    function obj = GuiComponent(gui,uihandle)
      obj@UiWrapper(uihandle);
      obj.gui = gui;
    end
    function val = get.sweep(obj)
      val = obj.gui.sweep;
    end
    function set.sweep(obj,val)
      obj.gui.sweep = val;
    end
    function val = get.triggertimes(obj)
      val = obj.gui.triggertimes;
    end
    function val = get.histogram_window(obj)
      val = obj.gui.histogram_window;
    end
    function set.histogram_window(obj,val)
      obj.gui.histogram_window = val;
    end
    function val = get.experiment(obj)
      val = obj.gui.experiment;
    end
    function set.experiment(obj,val)
      obj.gui.experiment = val;
    end
    function val = get.file(obj)
      val = obj.gui.file;
    end
    function set.file(obj,val)
      obj.gui.file = val;
    end
    function val = get.sequence(obj)
      val = obj.gui.sequence;
    end
    function set.sequence(obj,val)
      obj.gui.set_sequence(val);
    end
  end
end
