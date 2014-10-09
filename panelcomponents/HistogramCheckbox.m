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
        
        function updated = update(obj)
            obj.show_histogram_callback(true);
            updated = true;
        end
        
    end
    
    methods (Access = 'protected')
        function show_histogram_callback(obj,hide_panels)
            val = get(obj.ui_show_histogram,'value');
            if val
                if isempty(obj.gui.histogram)
                    obj.gui.histogram = HistogramChannel(obj.gui);
                end
            else
                obj.gui.histogram = [];
            end
            if nargin==1 || hide_panels
                obj.show_panels(false);
            end
        end
    end
end