classdef ChannelPanel < Panel
    methods
        function obj = ChannelPanel(gui)            
            panel = uipanel('Parent',gui.current_view,'Title','Main');
            obj@Panel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(MainChannel(obj));
            obj.gui_components.add(SubChannels(obj));
            obj.gui_components.add(TriggerSelection(obj));
            obj.gui_components.add(FilterOptions(obj));
            obj.gui_components.add(PlotOptions(obj));
            obj.gui_components.add(WaveformSelection(obj));
        end
    end
end