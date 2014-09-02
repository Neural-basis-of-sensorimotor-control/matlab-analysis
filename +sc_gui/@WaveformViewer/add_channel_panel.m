function add_channel_panel(obj)
panel = uipanel('title','Channels','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);

%Show digital channels
if obj.display_digital_channels
    mgr.newline(20);
    mgr.add(sc_ctrl('pushbutton','Show/hide digital channels',...
        @show_hide_channels_callback),200);
    mgr.newline(5);
end

%Select main channel
mgr.newline(20);
mgr.add(sc_ctrl('text','Main channel'),100);
ui_main_channel = mgr.add(sc_ctrl('popupmenu',[],...
    @main_channel_callback,'visible','off'),100);
mgr.newline(5);

mgr.newline(20);
ui_plot_raw = mgr.add(sc_ctrl('checkbox','Plot raw data',@plot_raw_callback,...
    'value',obj.plot_raw),200);
mgr.newline(5);

%Extra channels
ui_extra_channels = ScList();
for k=2:obj.nbr_of_analog_channels
    mgr.newline(20);
    mgr.add(sc_ctrl('text',sprintf('Channel #%i',k)),100);
    ui_channel = mgr.add(sc_ctrl('popupmenu',...
        [],@(~,~) obj.disable_panels(panel),'visible','off'),100);
    mgr.newline(5);
    ui_extra_channels.add(ui_channel);
end

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_callback),200);

mgr.newline(2);
mgr.trim();

obj.panels.add(panel);

sc_addlistener(obj,'update',@update_listener,panel);
addlistener(panel,'Visible','PostSet',@visible_listener);

    function show_hide_channels_callback(~,~)
        msgbox('To be implemented');
    end

    function main_channel_callback(~,~)
        val = get(ui_main_channel,'value');
        str = get(ui_main_channel,'string');
        signal = obj.sequence.signals.get('tag',str{val});
        obj.main_channel = signal;
        obj.disable_panels(panel);
    end

    function plot_raw_callback(~,~)
        obj.plot_raw = get(ui_plot_raw,'value');
    end

    function update_callback(~,~)
        main_channel_callback();
        obj.plot_axes = ScCellList();
        if obj.display_digital_channels
            obj.plot_axes.add(sc_gui.DigitalAxes(obj));
        end
        obj.plot_axes.add(sc_gui.AnalogAxes(obj,obj.main_channel,...
            'plot_raw',obj.plot_raw));
        
        for i=1:ui_extra_channels.n
            val = get(ui_extra_channels.get(i),'value');
            str = get(ui_extra_channels.get(i),'string');
            signal = obj.sequence.signals.get('tag',str{val});
            obj.plot_axes.add(sc_gui.AnalogAxes(obj,signal));
        end
        visible_listener();
        fcn = get(obj.current_view,'ResizeFcn');
        fcn();
    end

    function update_listener(~,~)
        str_tags = obj.signals.values('tag');
        set(ui_main_channel,'string',str_tags,'visible','on');
        val = [];
        if ~isempty(obj.temporary_signal_tags)
            val = find(cellfun(@(x) strcmp(x,obj.temporary_signal_tags{1}), ...
                str_tags),1);
        end
        obj.temporary_signal_tags = obj.temporary_signal_tags(2:end);
        if isempty(val)
            val = find(cellfun(@(x) ~isempty(strfind(x,'patch')), str_tags),1);
            if isempty(val)
                val = 1;
            end
        end
        set(ui_main_channel,'value',val);       
        for i=1:ui_extra_channels.n
            val = [];
            if ~isempty(obj.temporary_signal_tags)
                val = find(cellfun(@(x) strcmp(x,obj.temporary_signal_tags{1}), ...
                    str_tags),1);
                obj.temporary_signal_tags = obj.temporary_signal_tags(2:end);
            end
            if isempty(val)
                val = i+1;
            end
            set(ui_extra_channels.get(i),'string',str_tags,'value',val,'visible','on');
        end
        main_channel_callback();
        obj.disable_panels(panel);
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
