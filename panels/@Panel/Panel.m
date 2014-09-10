classdef Panel < UiWrapper & GuiComponent
    properties (SetObservable)
        enabled = false
    end
    
    methods (Abstract)
        populate_panel(obj,mgr)
        initialize_panel(obj)
        updated = update_panel(obj)
    end
    methods
        function obj = Panel(gui, panel)
            obj@UiWrapper(panel);
            obj@GuiComponent(gui);
        end
        
        function layout(obj)
            mgr = ScLayoutManager(obj.uihandle);
            mgr.newline(15);
            obj.populate_panel(mgr);
            mgr.newline(2);
            mgr.trim();
        end
        
    end
end