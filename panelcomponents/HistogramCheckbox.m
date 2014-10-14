classdef HistogramCheckbox < PanelComponent
    properties
        ui_show_histogram
    end
    
    methods
        function obj = HistogramCheckbox(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_show_histogram = mgr.add(sc_ctrl('checkbox',...
                'Show histogram',@(~,~) obj.show_histogram_callback),...
                200);
        end
        
        function initialize(obj)
            set(obj.ui_show_histogram,'value',obj.gui.show_histogram);
        end
        
%         function updated = update(obj)
%            % obj.show_histogram_callback();
%             updated = true;
%         end
%         
    end
    
    methods (Access = 'protected')
        function show_histogram_callback(obj)
            val = get(obj.ui_show_histogram,'value');
            if val
                if isempty(obj.gui.histogram)
                    obj.gui.histogram = HistogramChannel(obj.gui);
                    if isempty(obj.gui.histogram_window) || ~ishandle(obj.gui.histogram_window)
                        obj.gui.histogram_window = figure('Color',[0 0 0]);
                        set(obj.gui.histogram,'Parent',obj.gui.histogram_window);
                        set(obj.gui.histogram_window,'ResizeFcn',@(~,~) obj.gui.resize_histogram_window());
                    end
                end
                obj.panel.initialize_panel();
                obj.panel.update_panel();
            else
                obj.gui.histogram = [];
            end
        end
    end
end