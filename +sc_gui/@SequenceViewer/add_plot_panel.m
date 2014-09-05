function add_plot_panel(obj)
panel = uipanel('title','Plot','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
mgr.add(sc_ctrl('text','Pretrigger'),100);
ui_pretrigger = mgr.add(sc_ctrl('edit',obj.pretrigger,...
    @pretrigger_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Postrigger'),100);
ui_posttrigger = mgr.add(sc_ctrl('edit',obj.posttrigger,...
    @posttrigger_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Sweep'),100);
ui_sweep = mgr.add(sc_ctrl('edit',obj.sweep,@sweep_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Increment'),100);
ui_increment = mgr.add(sc_ctrl('edit',obj.sweep_increment,...
    @increment_callback),100);
mgr.newline(20);
ui_previous = mgr.add(sc_ctrl('pushbutton','Previous',@previous_callback),100);
ui_next = mgr.add(sc_ctrl('pushbutton','Next',@next_callback),100);

mgr.newline(20);
mgr.add(sc_ctrl('text','Plot mode'),100);
[~,str_] = enumeration('sc_gui.PlotModes');
ui_plot_mode = mgr.add(sc_ctrl('popupmenu',str_,@plot_mode_callback),100);

mgr.newline(20);
ui_zoom = mgr.add(sc_ctrl('pushbutton','Zoom',@zoom_callback),100);
ui_pan = mgr.add(sc_ctrl('pushbutton','Pan',@pan_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Reset',@reset_callback),100);
mgr.add(sc_ctrl('pushbutton','Y zoom out',@y_zoom_out_callback),100);

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_listener),200);

mgr.newline(2);
mgr.trim();
obj.panels.add(panel);

sc_addlistener(obj,'sweep',@sweep_listener,panel);
sc_addlistener(obj,'update',@update_listener,panel);
sc_addlistener(obj,'zoom_on',@(~,~) toggle_button('zoom_on',ui_zoom),panel);
sc_addlistener(obj,'pan_on',@(~,~) toggle_button('pan_on',ui_pan),panel);
sc_addlistener(obj,'plotmode',@plotmode_listener,panel);
addlistener(panel,'Visible','PostSet',@visible_listener);

    function pretrigger_callback(~,~)
        obj.pretrigger = str2double(get(ui_pretrigger,'string'));
        obj.xlimits(1) = obj.pretrigger;
    end

    function posttrigger_callback(~,~)
        obj.posttrigger = str2double(get(ui_posttrigger,'string'));
        obj.xlimits(2) = obj.posttrigger;
    end

    function increment_callback(~,~)
        obj.sweep_increment = str2double(get(ui_increment,'string'));
    end

    function sweep_callback(~,~)
        obj.set_sweep(str2num(get(ui_sweep,'string')));
    end

    function previous_callback(~,~)
        obj.set_sweep(obj.sweep-obj.sweep_increment);
    end

    function next_callback(~,~)
        obj.set_sweep(obj.sweep+obj.sweep_increment);
    end

    function plot_mode_callback(~,~)
        str = get(ui_plot_mode,'string');
        val = get(ui_plot_mode,'value');
        [enum,enum_str] = enumeration('sc_gui.PlotModes');
        ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
        obj.plotmode = enum(ind);
    end

    function zoom_callback(~,~)
        obj.zoom_on = ~obj.zoom_on;
    end

    function pan_callback(~,~)
        obj.pan_on = ~obj.pan_on;
    end

    function sweep_listener(~,~)
        sweep = obj.sweep;
        if size(sweep,1)>1, sweep = sweep'; end
        set(ui_sweep,'string',num2str(sweep));
    end

    function reset_callback(~,~)
        obj.xlimits = [obj.pretrigger obj.posttrigger];
        obj.zoom_on = false;
        obj.pan_on = false;
    end

    function y_zoom_out_callback(~,~)
        ylimits = ylim(obj.main_axes);
        ydiff = diff(ylimits);
        ylimits = ylimits + [-ydiff/2 ydiff/2];
        ylim(obj.main_axes,ylimits);
        obj.zoom_on = false;
        obj.pan_on = false;
    end

    function update_listener(~,~)
        obj.plot_channels();
    end

    function toggle_button(property, button)
        if obj.(property)
            set(button,'FontWeight','bold');
        else
            set(button,'FontWeight','normal');
        end
    end

    function plotmode_listener(~,~)
        for k=1:obj.plot_axes.n
            cla(obj.plot_axes.get(k).ax);
        end
        if obj.plotmode == sc_gui.PlotModes.plot_all || ...
                obj.plotmode == sc_gui.PlotModes.plot_avg_std_all
            set(ui_sweep,'enable','off');
            set(ui_increment,'enable','off');
            set(ui_next,'enable','off');
            set(ui_previous,'enable','off');
        else
            set(ui_sweep,'enable','on');
            set(ui_increment,'enable','on');
            set(ui_next,'enable','on');
            set(ui_previous,'enable','on');
        end
    end

    function visible_listener(~,~)
        visible  = get(panel,'Visible');
        if strcmp(visible,'on')
            obj.enable_panels(panel);
        else
            obj.disable_panels(panel);
        end
    end
end
