function add_main_panel(obj)

panel = uipanel('title','Main','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);
mgr.newline(20);

%Determine what implementation of SequenceViewer to use
mgr.add(sc_ctrl('text','Mode'),100);
[~,str_] = enumeration('ScGuiState');
ui_mode = mgr.add(sc_ctrl('popupmenu',str_,@(~,~) obj.disable_panels(panel)),100);
set(ui_mode,'value',find(obj.mode == enumeration('ScGuiState')));
mgr.newline(5);

%Show digital channels
mgr.newline(20);
ui_display_digital_channels = mgr.add(sc_ctrl('checkbox','Display digital channels', ...
    @(~,~) obj.disable_panels(panel),'value',obj.display_digital_channels),...
    200);
mgr.newline(5);

%Number of analog channels
mgr.newline(20);
mgr.add(sc_ctrl('text','Number of channels'),100);
ui_nbr_of_channels = mgr.add(sc_ctrl('popupmenu',1:obj.sequence.signals.n,...
    @(~,~) obj.disable_panels(panel),'value',obj.nbr_of_analog_channels),100);
mgr.newline(5);

%Show histogram axes
mgr.newline(20);
ui_display_histogram_axes = mgr.add(sc_ctrl('checkbox','Display histogram',...
    @(~,~) obj.disable_panels(panel),'value',obj.display_histogram),200);
mgr.newline(5);

%Save changes
mgr.newline(20);
ui_save  = mgr.add(sc_ctrl('pushbutton','Save changes',@save_callback),200);

%Update
mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_callback),200);

mgr.newline(2);
mgr.trim();
obj.panels.add(panel);

sc_addlistener(obj,'has_unsaved_changes',@has_unsaved_changes_listener,panel);

    function save_callback(~,~)
        obj.sequence.sc_save();
    end

    function update_callback(~,~)
        str = get(ui_mode,'string');
        val = get(ui_mode,'value');
        [enum,enum_str] = enumeration('ScGuiState');
        ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
        mode = enum(ind);
        if mode ~= obj.mode
            switch mode
                case ScGuiState.spike_detection
                    newobj = sc_gui.WaveformViewer(obj.sequence);
                    obj.copy_attributes(newobj);
                    obj = newobj;
                case ScGuiState.ampl_analysis
                    newobj = sc_gui.AmplitudeViewer(obj.sequence);
                    obj.copy_attributes(newobj);
                    obj = newobj;
            end
        end                  
        obj.display_digital_channels = get(ui_display_digital_channels,'value');
        obj.nbr_of_analog_channels = get(ui_nbr_of_channels,'value');
        obj.display_histogram = get(ui_display_histogram_axes,'value');
        obj.show();
    end

    function has_unsaved_changes_listener(~,~)
        if obj.has_unsaved_changes
            set(ui_save,'enable','on');
        else
            set(ui_save,'enable','inactive');
        end
    end
end