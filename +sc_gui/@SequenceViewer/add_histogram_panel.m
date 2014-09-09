function add_histogram_panel(obj)

panel = uipanel('title','Histogram','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
mgr.add(sc_ctrl('text','Pretrigger'),100);
ui_pretrigger = mgr.add(sc_ctrl('edit',obj.hist_pretrigger,@pretrigger_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Posttrigger'),100);
ui_posttrigger = mgr.add(sc_ctrl('edit',obj.hist_posttrigger,@posttrigger_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Bin width'),100);
ui_binwidth = mgr.add(sc_ctrl('edit',obj.hist_binwidth,@binwidth_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Histogram type'),100);
ui_histogram_type = mgr.add(sc_ctrl('popupmenu',[],@type_callback),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Pretrigger'),100);
ui_update = mgr.add(sc_ctrl('pushbutton','Update',@update_callback),100);

mgr.newline(2);
mgr.trim();
obj.panels.add(panel);

sc_addlistener(obj,'update',@update_listener,panel);
sc_addlistener(obj,'waveform',@waveform_listener,panel);

    function pretrigger_callback(~,~)
        obj.hist_pretrigger = str2double(get(ui_pretrigger,'string'));
    end

    function posttrigger_callback(~,~)
        obj.hist_posttrigger = str2double(get(ui_posttrigger,'string'));
    end
    function binwidth_callback(~,~)
        obj.hist_binwidth = str2double(get(ui_binwidth,'string'));
    end
    function type_callback(~,~)
        enum = enumeration('sc_gui.HistogramType');
        value = get(ui_histogram_type,'value');
        obj.hist_type = enum(value);
    end

    function update_callback(~,~)
        obj.histogram_channel.plotch();
    end

    function update_listener(~,~)
        set(ui_pretrigger,'string',obj.hist_pretrigger);
        set(ui_posttrigger,'string',obj.hist_posttrigger);
        set(ui_binwidth,'string',obj.hist_binwidth);
        [enum,str] = enumeration('sc_gui.HistogramType');
        set(ui_histogram_type,'string',str,'value',find(enum==obj.hist_type));
    end

    function waveform_listener(~,~)
        if isempty(obj.waveform)
            set(panel,'visible','off');
        else
            set(panel,'visible','on');
        end
    end


end