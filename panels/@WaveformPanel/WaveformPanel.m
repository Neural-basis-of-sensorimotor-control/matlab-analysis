classdef WaveformPanel < Panel
    methods
        function obj = WaveformPanel(gui)            
            panel = uipanel('Parent',gui.current_view,'Title','Waveform');
            obj@Panel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(WaveformSelection(obj));
        end
        
    end
end