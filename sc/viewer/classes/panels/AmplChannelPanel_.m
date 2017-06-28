classdef AmplChannelPanel_ < ChannelPanel
  %For AmplitudeViewer
  methods
    function obj = AmplChannelPanel_(gui)  
      obj@ChannelPanel(gui);
      obj.layout();
    end
    function setup_components(obj)
      obj.gui_components.add(MainChannel(obj));
      obj.gui_components.add(SubChannels(obj));
      obj.gui_components.add(SetAxesHeight(obj));
      %obj.gui_components.add(TriggerSelection(obj));
      obj.gui_components.add(FilterOptions(obj));
      obj.gui_components.add(PlotOptions(obj));
      obj.gui_components.add(AmplitudeSelection(obj));
      %obj.gui_components.add(WaveformSelection(obj));
      %obj.gui_components.add(SpikeRemovalSelection(obj));
      setup_components@UpdatablePanel(obj);
    end
  end

end
