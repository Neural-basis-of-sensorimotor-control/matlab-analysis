classdef PanelComponent < GuiComponent
    %Component to be added to Panel object
    methods (Abstract)
        populate(obj,mgr)
    end
    properties
        panel   %Panel object
    end
    
    properties (Dependent)
        children
    end
    
    methods
        function obj = PanelComponent(panel)
            obj@GuiComponent(panel.gui,panel.uihandle);
            obj.panel = panel;
        end
        
        %Is being called to update graphic object
        %Override to change specific data
        function initialize(~)
        end
        
        %Is being called to reload data
        %Override to implement update routine
        function updated = update(~)
            updated = true;
        end
        
        %Is being called to enable/disable parent panel, thereby invoking
        %enabled listener in parent
        function show_panels(obj,visible)
            if visible
                obj.gui.enable_panels(obj.panel);
            else
                obj.gui.disable_panels(obj.panel);
            end
        end
        
        %Get all graphics object that are part of this PanelComponent
        function children = get.children(obj)
            children = get(obj.uihandle,'children');
        end
        
        function automatic_update(obj)
            if obj.gui.automatic_update_on
                obj.panel.update_panel;
            end
        end
        
    end
end