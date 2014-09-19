classdef Panel < GuiComponent
    properties (SetObservable)
        enabled = false
    end
    
    properties
        gui_components
    end
    
    methods (Abstract)
        setup_components(obj);
    end
    
    methods
        function obj = Panel(gui, panel)
            obj@GuiComponent(gui,panel);
            addlistener(obj,'enabled','PostSet',@(~,~) obj.enabled_listener);
        end
        
        function layout(obj)
            obj.gui_components = ScCellList();
            obj.setup_components();
            mgr = ScLayoutManager(obj.uihandle);
            mgr.newline(15);
            for k=1:obj.gui_components.n
                obj.gui_components.get(k).populate(mgr);
            end
            mgr.newline(2);
            mgr.trim();
        end
        
        function initialize_panel(obj)
            for k=1:obj.gui_components.n
                obj.gui_components.get(k).initialize();
            end
        end
        
        function update_panel(obj)
            updated = true;
            for k=1:obj.gui_components.n
                updated = updated & obj.gui_components.get(k).update();
            end
            obj.enabled = updated;
        end
    end
    
    methods (Access = 'protected')
        function enabled_listener(obj)
            obj.dbg_in(mfilename','Panel','enabled_listener','enabled = ',obj.enabled);
            if obj.enabled
                set(obj.uihandle,'Visible','on');
            else
                set(obj.uihandle,'Visible','off');
            end
            obj.dbg_out(mfilename','Panel','enabled_listener');
        end
    end
end