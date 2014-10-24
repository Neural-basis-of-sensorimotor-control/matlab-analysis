classdef TriggerSelection < PanelComponent
    properties
        ui_trigger
        ui_triggerparent
        ui_nbr_of_sweeps
    end
    
    methods
        function obj = TriggerSelection(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Trigger parent'),100);
            obj.ui_triggerparent = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.triggerparent_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Trigger'),100);
            obj.ui_trigger = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.trigger_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            mgr.newline(20);
            obj.ui_nbr_of_sweeps = mgr.add(sc_ctrl('text',[]),200);

            sc_addlistener(obj.gui,'triggerparent',@(~,~) obj.triggerparent_listener(),obj.uihandle);
            sc_addlistener(obj.gui,'trigger',@(~,~) obj.trigger_listener(),obj.uihandle);
        end
        
        function initialize(obj)
            obj.sequence_listener();
            val = get(obj.ui_triggerparent,'value');
            str = get(obj.ui_triggerparent,'string');
            obj.gui.triggerparent = obj.gui.triggerparents.get('tag',str{val});
            obj.triggerparent_listener();
            val = get(obj.ui_trigger,'value');
            str = get(obj.ui_trigger,'string');
            obj.gui.trigger = obj.gui.triggers.get('tag',str{val});
            obj.trigger_listener();
        end
        
        function updated = update(obj)

            obj.triggerparent_listener();
            obj.trigger_listener();
            updated = numel(obj.gui.triggertimes) > 0;
        end
    end
    
    methods (Access = 'protected')
        function triggerparent_callback(obj) 
            val = get(obj.ui_triggerparent,'value');
            str = get(obj.ui_triggerparent,'string');
            obj.gui.triggerparent = obj.gui.triggerparents.get('tag',str{val});
            obj.show_panels(false);
        end
        
        function trigger_callback(obj)
            val = get(obj.ui_trigger,'value');
            str = get(obj.ui_trigger,'string');
            obj.gui.trigger = obj.gui.triggers.get('tag',str{val});
            obj.show_panels(false);
        end
        
        function sequence_listener(obj)
            if ~isempty(obj.gui.sequence) 
                str = cell(obj.gui.triggerparents.n,1);
                for k=1:obj.gui.triggerparents.n
                    str(k) = {obj.gui.triggerparents.get(k).tag};
                end
                if obj.gui.triggerparents.n
                    str = obj.gui.triggerparents.values('tag');
                    set(obj.ui_triggerparent,'string',str);
                end
            end
        end
        
        function triggerparent_listener(obj)
            if isempty(obj.gui.triggerparent)
                set(obj.ui_triggerparent,'visible','off');
                set(obj.ui_trigger,'visible','off');
            else
                str = obj.gui.triggerparents.values('tag');
                val = find(cellfun(@(x) strcmp(x,obj.gui.triggerparent.tag),str));
                set(obj.ui_triggerparent,'string',str,'value', val,...
                    'visible','on');
            end
        end
        
        function trigger_listener(obj)
            
            if isempty(obj.gui.trigger)
                set(obj.ui_trigger,'visible','off');
                set(obj.ui_nbr_of_sweeps,'string','No triggers to show');
            else
                str = obj.gui.triggerparent.triggers.values('tag');
                trigger = obj.gui.trigger.tag;
                val = find(cellfun(@(x) strcmp(trigger,x),str));
                set(obj.ui_trigger,'string',str,'value',val,'visible','on');
                set(obj.ui_nbr_of_sweeps,'string',sprintf('Total nbr of sweeps: %i',...
                    numel(obj.gui.triggertimes)));
            end
            
        end
        
    end
end