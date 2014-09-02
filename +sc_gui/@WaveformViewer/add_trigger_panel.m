function add_trigger_panel(obj)
panel = uipanel('title','Trigger','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);

%Select trigger
mgr.newline(20);
mgr.add(sc_ctrl('text','Trigger parent'),100);
ui_trigger_parent = mgr.add(sc_ctrl('popupmenu',[],@triggerparent_callback,...
    'visible','off'),100);
mgr.newline(5);

mgr.newline(20);
mgr.add(sc_ctrl('text','Trigger'),100);
ui_trigger = mgr.add(sc_ctrl('popupmenu',[],@trigger_callback,...
    'visible','off'),100);
mgr.newline(5);

mgr.newline(20);
ui_nbr_of_sweeps = mgr.add(sc_ctrl('text',[]),200);

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_callback),200);

mgr.newline(2);
mgr.trim();

obj.panels.add(panel);

sc_addlistener(obj,'update',@update_listener,panel);
sc_addlistener(obj,'triggerparent',@triggerparent_listener,panel);
sc_addlistener(obj,'trigger',@trigger_listener,panel);
addlistener(panel,'Visible','PostSet',@visible_listener);

    function triggerparent_callback(~,~)
        val = get(ui_trigger_parent,'value');
        str = get(ui_trigger_parent,'string');
        obj.triggerparent = obj.triggerparents.get('tag',str{val});
        obj.disable_panels(panel);
    end

    function trigger_callback(~,~)        
        val = get(ui_trigger,'value');
        str = get(ui_trigger,'string');
        obj.trigger = obj.triggers.get('tag',str{val});
        obj.disable_panels(panel);
    end

    function update_callback(~,~)
        visible_listener();
        fcn = get(obj.current_view,'ResizeFcn');
        fcn();
    end

    function update_listener(~,~)
       set(ui_trigger_parent,'string',obj.triggerparents.values('tag'),...
           'value',1,'visible','on');
       triggerparent_callback();
       obj.disable_panels(panel);
    end

    function triggerparent_listener(~,~)
        set(ui_trigger,'string',obj.triggerparent.triggers.values('tag'),...
            'visible','on');
        trigger_callback();
    end

    function trigger_listener(~,~)
        set(ui_nbr_of_sweeps,'string',sprintf('Total nbr of sweeps: %i',...
            numel(obj.triggertimes)));
    end

    function visible_listener(~,~)
        visible  = get(panel,'Visible');
        if strcmp(visible,'on')
            if numel(obj.triggertimes)
                obj.enable_panels(panel);
            else
                obj.disable_panels(panel);
            end
        else
            obj.disable_panels(panel);
        end
    end



end