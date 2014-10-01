classdef HistogramPanel < Panel
    methods
        function obj = HistogramPanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Histogram');
            obj@Panel(gui,panel);
            obj.layout();
            
            sc_addlistener(gui,'histogram',@(~,~) obj.histogram_listener,panel);
        end
        
        function setup_components(~)
            fprintf('%s: to be implemented\n',mfilename);
        end
        
        function update_panel(obj)
            update_panel@Panel(obj);
            obj.histogram_listener();
        end
    
        function enabled_listener(obj)
            obj.dbg_in(mfilename','HistogramPanel','enabled_listener','enabled = ',obj.enabled);
            
            obj.dbg_out(mfilename','HistogramPanel','enabled_listener');
        end
    end
    
    methods (Access = 'protected')
        function histogram_listener(obj)
            if isempty(obj.gui.histogram)
                obj.enabled = false;
            else
                obj.enabled = true;
            end
        end
    end
end