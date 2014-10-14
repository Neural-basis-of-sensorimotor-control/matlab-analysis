classdef HistogramPanel < UpdatablePanel%SequenceDependentPanel
    methods
        function obj = HistogramPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Histogram');
            obj@UpdatablePanel(gui,panel);
            obj.layout();
            
%             sc_addlistener(gui,'histogram',@(~,~) obj.histogram_listener,panel);
        end
        
        function setup_components(obj)
            obj.gui_components.add(HistogramCheckbox(obj));
            obj.gui_components.add(HistogramParameters(obj));
            obj.gui_components.add(SaveHistogram(obj));
            setup_components@UpdatablePanel(obj);
        end
        
%         function update_panel(obj)
%           %  update_panel@SequenceDependentPanel(obj);
%             obj.histogram_listener();
%         end
    
        function enabled_listener(~)
%             obj.dbg_in(mfilename','HistogramPanel','enabled_listener','enabled = ',obj.enabled);
%             
%             obj.dbg_out(mfilename','HistogramPanel','enabled_listener');
        end
    end
    
    methods (Access = 'protected')
%         function histogram_listener(obj)
%             if isempty(obj.gui.histogram)
%                 obj.enabled = false;
%             else
%                 obj.enabled = true;
%             end
%         end
    end
end