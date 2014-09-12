classdef PanelComponent < GuiComponent
    
    properties
        panel;
    end
    
    methods (Abstract)
        populate(obj,mgr)
    end
    
    methods
        function obj = PanelComponent(panel)
            obj@GuiComponent(panel.gui,panel.uihandle);
            obj.panel = panel;
        end
        
        %Override to change specific data
        function initialize(~)
        end
        
        %Override to implement update routine
        function updated = update(~)
            updated = true;
        end
        
        function show_panels(obj,visible)
            if visible
                obj.gui.enable_panels(obj.panel);
            else
                obj.gui.disable_panels(obj.panel);
            end
        end
        
    end
end