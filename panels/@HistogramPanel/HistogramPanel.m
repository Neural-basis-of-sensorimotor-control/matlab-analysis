classdef HistogramPanel < Panel
    methods
        function obj = HistogramPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Histogram');
            obj@Panel(gui,panel);
            obj.layout();    
        end
        
        function setup_components(obj)
            obj.gui_components.add(HistogramCheckbox(obj));
            obj.gui_components.add(HistogramParameters(obj));
            obj.gui_components.add(SaveHistogram(obj));
            obj.gui_components.add(UpdateHistogramButton(obj));
        end    
    
        function enabled_listener(~)
            %Overriding parent function
        end
        
        function update_panel(~)
             %Overriding parent function    
        end
    end
    
    methods (Access = 'protected')
        
    end
end