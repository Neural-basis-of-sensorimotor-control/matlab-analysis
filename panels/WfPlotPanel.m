classdef WfPlotPanel < PlotPanel
  methods
    function obj = WfPlotPanel(gui)
      obj@PlotPanel(gui);
      obj.layout();
    end
    
    function setup_components(obj)
      obj.gui_components.add(OffsetAtTime(obj));
      obj.gui_components.add(SweepOptions(obj));
      obj.gui_components.add(AbsoluteTime(obj));
      obj.gui_components.add(ZoomOptions(obj));
      obj.gui_components.add(ThresholdOptions(obj));
      obj.gui_components.add(RemoveWaveformAll(obj));
      obj.gui_components.add(PlotMode(obj));
      obj.gui_components.add(ManualSpikeTimes(obj));
      obj.gui_components.add(SavePlotOptions(obj));
      obj.gui_components.add(SaveSpikeTimesOptions(obj));
      setup_components@UpdatablePanel(obj);
    end
    
    
  end
  
  methods
  
  end
end
