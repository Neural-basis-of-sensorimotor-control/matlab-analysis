classdef TriggerSelection < PanelComponent
    properties
        ui_trigger
        ui_trigger_parent
        ui_nbr_of_sweeps
    end
    
    methods
        function obj = TriggerSelection(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Trigger parent'),100);
            obj.ui_trigger_parent = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.triggerparent_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Trigger'),100);
            obj.ui_trigger = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.trigger_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            mgr.newline(20);
            obj.ui_nbr_of_sweeps = mgr.add(sc_ctrl('text',[]),200);
            
            sc_addlistener(obj.gui,'triggerparent',@triggerparent_listener,obj.uihandle);
            sc_addlistener(obj.gui,'trigger',@trigger_listener,obj.uihandle);

        end
        
        function triggerparent_callback(obj)
            val = get(obj.ui_trigger_parent,'value');
            str = get(obj.ui_trigger_parent,'string');
            obj.gui.triggerparent = obj.gui.triggerparents.get('tag',str{val});
            obj.show_panels(false);
        end
        
        function trigger_callback(obj)
            val = get(obj.ui_trigger,'value');
            str = get(obj.ui_trigger,'string');
            obj.gui.trigger = obj.gui.triggers.get('tag',str{val});
            obj.show_panels(false);
        end
        
        function triggerparent_listener(~,~)
            set(obj.ui_trigger,'string',obj.gui.triggerparent.triggers.values('tag'),...
                'visible','on');
            trigger_callback();
        end
        
        function trigger_listener(~,~)
            set(obj.ui_nbr_of_sweeps,'string',sprintf('Total nbr of sweeps: %i',...
                numel(obj.gui.triggertimes)));
        end
        
        function initialize(obj)
            set(obj.ui_trigger_parent,'string',obj.gui.triggerparents.values('tag'),...
                'value',1,'visible','on');
            obj.triggerparent_callback();
        end
        
        function updated = update(obj)
            updated = numel(obj.gui.triggertimes) > 0;
        end
    end
end