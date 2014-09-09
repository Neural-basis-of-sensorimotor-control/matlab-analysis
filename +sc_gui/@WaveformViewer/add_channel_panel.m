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
ui_main_signal = mgr.add(sc_ctrl('popupmenu',[],...
    @main_signal_callback,'visible','off'),100);
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
mgr.add(sc_ctrl('text','Waveform'),100);
ui_waveforms = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.disable_panels(panel),'visible','off'),100);

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Add waveform',@(~,~) obj.create_new_waveform),200);

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_callback),200);

mgr.newline(2);
mgr.trim();

obj.panels.add(panel);

sc_addlistener(obj,'update',@update_listener,panel);
sc_addlistener(obj,'waveform',@waveform_listener,panel);
addlistener(panel,'Visible','PostSet',@visible_listener);

    function show_hide_channels_callback(~,~)
        msgbox('To be implemented');
    end

    function main_signal_callback(~,~)
        val = get(ui_main_signal,'value');
        str = get(ui_main_signal,'string');
        signal = obj.sequence.signals.get('tag',str{val});
        obj.main_signal = signal;
        if obj.main_signal.waveforms.n
            if ~isempty(obj.waveform)
                str = obj.main_signal.waveforms.values('tag');
                ind = find(cellfun(@(x) strcmp(x,obj.waveform.tag), str));
                if isempty(ind),    ind = 1;    end
            else
                ind = 1;
            end
            set(ui_waveforms,'string',str,'value',ind,'visible','on');
            obj.waveform = obj.main_signal.waveforms.get(ind);
        else
            set(ui_waveforms,'visible','off');
            obj.waveform = [];
        end
        obj.disable_panels(panel);
    end

    function plot_raw_callback(~,~)
        obj.plot_raw = get(ui_plot_raw,'value');
    end

    function update_callback(~,~)
        main_signal_callback();
        obj.plot_axes = ScCellList();
        if obj.display_digital_channels
            obj.plot_axes.add(sc_gui.DigitalAxes(obj));
        end
        obj.main_channel = sc_gui.AnalogAxes(obj,obj.main_signal,...
            'plot_raw',obj.plot_raw);
        obj.plot_axes.add(obj.main_channel);
        
        for i=1:ui_extra_channels.n
            val = get(ui_extra_channels.get(i),'value');
            str = get(ui_extra_channels.get(i),'string');
            signal = obj.sequence.signals.get('tag',str{val});
            obj.plot_axes.add(sc_gui.AnalogAxes(obj,signal));
        end
        obj.histogram_channel = sc_gui.HistogramChannel(obj);
        obj.plot_axes.add(obj.histogram_channel);
        visible_listener();
        fcn = get(obj.current_view,'ResizeFcn');
        fcn();
    end

    function update_listener(~,~)
        str_tags = obj.signals.values('tag');
        set(ui_main_signal,'string',str_tags,'visible','on');
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
        set(ui_main_signal,'value',val);
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
        main_signal_callback();
        obj.disable_panels(panel);
    end

    function waveform_listener(~,~)
        
        if ~isempty(obj.waveform)
            str = obj.main_signal.waveforms.values('tag');
            ind = find(cellfun(@(x) strcmp(x,obj.waveform.tag), str));
            if isempty(ind),    ind = 1;    end
            set(ui_waveforms,'string',str,'value',ind,'visible','on');
        else
            set(ui_waveforms,'visible','off');
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
