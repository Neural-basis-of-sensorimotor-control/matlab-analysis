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
            mgr.newline(obj.upper_margin());
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
        
        function lock_panel(obj,do_lock)
            if do_lock
                enablestr = 'off';
            else
                enablestr = 'on';
            end
            children = get(obj.uihandle,'children');
            set(children,'Enable',enablestr);
        end
    end
    
    
    methods (Static)
        function val = upper_margin()
            val = 15;
        end
    end
    
    methods %(Access = 'protected')
        function enabled_listener(obj)
            obj.dbg_in(mfilename','Panel','enabled_listener','enabled = ',obj.enabled);
            index = obj.gui.panels.indexof(obj);
            if index<2 || obj.gui.panels.get(index-1).enabled
                previous_panel_enabled = true;
            else
                previous_panel_enabled = false;
            end
            if obj.enabled || previous_panel_enabled
                obj.initialize_panel();
                set(obj.uihandle,'Visible','on');
            else
                set(obj.uihandle,'Visible','off');
            end
            if obj.enabled && index > -1 && index < obj.gui.panels.n
                set(obj.gui.panels.get(index+1),'Visible','on');
            end
            obj.dbg_out(mfilename','Panel','enabled_listener');
        end
    end
end