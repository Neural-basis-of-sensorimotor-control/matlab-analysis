function panel = get_triggerpanel(obj)

layout_done = false;

panel = uipanel('title','Trigger');
obj.triggerpanel = panel;

mgr = ScLayoutManager(panel);
mgr.newline(15);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    mgr.add(getuitext('Signal'),100);
    ui_signal = mgr.add(sc_ctrl('popupmenu',[],@signal_callback,'visible','off'),100);
    sc_addlistener(obj,'sequence_',@sequence_listener,ui_signal);
    mgr.newline(5);
end

mgr.newline(20);
mgr.add(getuitext('Smoothing width:'),100);
ui_smoothing_width = mgr.add(uicontrol('style','edit',...
    'callback',@filter_callback),100);
mgr.add(getuitext('bins (1 = off)'),80);

mgr.newline(20);
mgr.add(getuitext('Artifact width'),100);
ui_artifact_width = mgr.add(uicontrol('style','edit',...
    'callback',@filter_callback),100);
mgr.add(getuitext('bins (0 = off)'),80);

mgr.newline(20);
if obj.state == ScGuiState.spike_detection
    mgr.add(sc_ctrl('text','Waveform','HorizontalAlignment','left'),100);
    ui_waveform = mgr.add(sc_ctrl('popupmenu',[],@waveform_callback,'visible','off'),100);
    sc_addlistener(obj,'signal_',@signal_waveform_listener,ui_waveform);
    ui_new_waveform = mgr.add(sc_ctrl('pushbutton','New waveform',@new_waveform_callback),100);
    sc_addlistener(obj,'signal_',@signal_waveform_listener,ui_new_waveform);
elseif obj.state == ScGuiState.ampl_analysis
    mgr.add(sc_ctrl('text','Amplitudes','HorizontalAlignment','left'),100);
    ui_ampl = mgr.add(sc_ctrl('popupmenu',[],@ampl_callback,'visible','off'),100);
    sc_addlistener(obj,'sequence_',@sequence_ampl_listener,ui_ampl);
    sc_addlistener(obj,'signal_',@signal_listener,ui_ampl);
    ui_new_ampl = mgr.add(sc_ctrl('pushbutton','New amplitude',@new_ampl_callback),100);
    sc_addlistener(obj,'sequence_',@sequence_ampl_listener,ui_new_ampl);
    sc_addlistener(obj,'signal_',@signal_listener,ui_new_ampl);
end

    function ampl_callback(src,~)
        val = get(src,'Value');
        str = get(src,'string');
        tag = str{val};
        obj.ampl = obj.sequence.ampl_list.get('tag',tag);
    end

    function new_ampl_callback(~,~)
        obj.new_amplitude();
    end

    function signal_waveform_listener(~,~)
        if isempty(obj.signal)
            set(ui_waveform,'string',[],'visible','off');
            set(ui_new_waveform,'visible','off');
        elseif ~obj.signal.waveforms.n
            set(ui_waveform,'string',[],'visible','off');
            set(ui_new_waveform,'visible','on');
        else
            set(ui_waveform,'string',obj.signal.waveforms.values('tag'),...
                'Value',obj.signal.waveforms.indexof(obj.waveform),'visible','on');
            set(ui_new_waveform,'visible','on');
        end
        signal_listener();
    end

    function sequence_ampl_listener(~,~)
        if isempty(obj.sequence)
            set(ui_ampl,'visible','off','string',[]);
            set(ui_new_ampl,'visible','off');
        elseif ~obj.sequence.ampl_list.n
            set(ui_ampl,'visible','off','string',[]);
            set(ui_new_ampl,'visible','on');
        else
            set(ui_ampl,'visible','on','string',obj.sequence.ampl_list.values('tag'),...
                'Value',obj.sequence.ampl_list.indexof(obj.ampl));
            set(ui_new_ampl,'visible','on');
        end
        %sequence_listener();
    end

    function sequence_listener(~,~)
        if isempty(obj.sequence)
            set(ui_signal,'visible','off','string',[]);
        else
            set(ui_signal,'visible','on','String',obj.sequence.signals.values('tag'),...
                'Value',obj.sequence.signals.indexof(obj.signal));
        end
    end

    function signal_listener(~,~)
        if ~isempty(obj.signal)
            set(ui_smoothing_width,'string',obj.signal.filter.smoothing_width,...
                'visible','on');
            set(ui_artifact_width,'string',obj.signal.filter.artifact_width,...
                'visible','on');
            %signal_callback();
        else
            set(ui_smoothing_width,'visible','off');
            set(ui_artifact_width,'visible','off');
        end
        if isempty(obj.signal) || isempty(obj.trigger)
            set(ui_load,'style','text','fontweight','bold','string',...
                'No signal or trigger, cannot load data','enable','inactive');
        else
            set(ui_load,'style','pushbutton','fontweight','normal','string',...
                'Load signal','enable','on');
        end
    end


mgr.newline(5);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    ui_no_trigger = mgr.add(uicontrol('style','checkbox','String','No trigger',...
        'Callback',@no_trigger_callback,'Value',obj.no_trigger),100);
    
    mgr.newline(20);
    mgr.add(getuitext('Trigger'),100);
    ui_triggerchannel = mgr.add(uicontrol('style','popupmenu','callback',...
        @triggerchannel_callback,'Visible','off'),100);
    triggerchannel = [];
    
    ui_trigger = mgr.add(uicontrol('style','popupmenu','callback',...
        @trigger_callback,'Visible','off'),100);
    
    mgr.newline(10);
    
    mgr.newline(20)
    mgr.add(getuitext('Remove stims:'),100);
    
end

for i=1:obj.extrasignalaxes.n
    mgr.newline(20);
    mgr.add(getuitext(['Plot ' num2str(i+1)]),100);
    src = mgr.add(uicontrol('style','popupmenu','string',...
        {obj.sequence.signals.list.tag},'Value',i+1,'callback',...
        @(src,~) extrasignal_callback(src,i)),100);
    extrasignal_callback(src,i);
    mgr.newline(10);
end

mgr.newline(20);
mgr.add(getuitext('Pretrigger'),75);
ui_pretrigger = mgr.add(uicontrol('style','edit','string',obj.pretrigger,...
    'callback',@range_callback),75);
mgr.add(getuitext('Posttrigger'),70);
ui_posttrigger = mgr.add(uicontrol('style','edit','string',obj.posttrigger,...
    'callback',@range_callback),75);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    ui_plot_waveforms = mgr.add(uicontrol('style','checkbox','string',...
        'Plot waveform shapes (requires more time to load)',...
        'callback',@plot_waveforms_callback,'Value',obj.plot_waveform_shapes),300);
end

mgr.newline(20);
ui_plot_raw = mgr.add(uicontrol('style','checkbox','string','Plot raw data',...
    'Value',obj.plot_raw,'callback',@(~,~) set_visible(0)),100);

mgr.newline(20);
ui_load = mgr.add(uicontrol('style','pushbutton','string',...
    'Load membrane potential (required for waveform shapes)','callback',...
    @load_callback),obj.leftpanelwidth);
if obj.state == ScGuiState.ampl_analysis
    sc_addlistener(obj,'ampl_',@ampl_listener,ui_load);
end

    function ampl_listener(~,~)
        if isempty(obj.ampl)
            set(ui_load,'style','text','string',...
                sprintf('You must press ''%s'' to load',get(ui_new_ampl,'string')),...
                'enable','inactive','Fontweight','bold');
            set(ui_ampl,'visible','off');
        else
            set(ui_load,'style','pushbutton','string',...
                'Load analog signals',...
                'enable','on','Fontweight','normal');
            set(ui_ampl,'visible','on','string',obj.sequence.ampl_list.values('tag'),...
                'value',obj.sequence.ampl_list.indexof(obj.ampl));
        end
    end

mgr.newline(2);
mgr.trim;

%obj.update_triggerpanel_fcn = @update_triggerpanel;
obj.load_sequence_fcn = @load_callback;
sc_addlistener(obj,'trigger_',@trigger_listener,panel);
sc_addlistener(obj,'signal_',@signal_listener,panel);

layout_done = true;

    function trigger_listener(~,~)
        set_visible(0);
        if obj.no_trigger
            set(ui_triggerchannel,'Visible','off');
            set(ui_trigger,'Visible','off');
            obj.trigger = ScSpikeTrain('',...
                obj.sequence.tmin-obj.pretrigger:(obj.posttrigger-obj.pretrigger):...
                obj.sequence.tmax);
        else
            if obj.state == ScGuiState.spike_detection
                str = obj.sequence.gettriggerchannels(obj.tmin,obj.tmax).values('tag');
                
                triggernbr = find(cellfun(@(x) strcmpi(x,'DigMark') || ...
                    strcmpi(x,'Trigger'),str),1);
                if ~isempty(str)
                    set(ui_triggerchannel,'string',str);
                    if ~isempty(triggernbr)
                        set(ui_triggerchannel,'Value',triggernbr);
                    else
                        set(ui_triggerchannel,'Value',1);
                    end
                    triggerchannel_callback();
                    set(ui_triggerchannel,'Visible','on');
                else
                    set(ui_triggerchannel,'Visible','off');
                end
            end
        end
        if isempty(obj.signal) || isempty(obj.trigger)
            set(ui_load,'style','text','fontweight','bold','string',...
                'No signal or trigger, cannot load data','enable','inactive');
        else
            set(ui_load,'style','pushbutton','fontweight','normal','string',...
                'Load signal','enable','on');
        end
    end

    function no_trigger_callback(~,~)
        obj.no_trigger = get(ui_no_trigger,'Value');
        %trigger_listener();
    end

    function signal_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        
        str = get(ui_signal,'String');
        val = get(ui_signal,'Value');
        tag = str{val};
        obj.signal = obj.sequence.signals.get('tag',tag);
        
%         if obj.state == ScGuiState.spike_detection
%             str = obj.sequence.gettriggerchannels(obj.tmin,obj.tmax).values('tag');
%             
%             triggernbr = find(cellfun(@(x) strcmpi(x,'DigMark') || ...
%                 strcmpi(x,'Trigger'),str),1);
%             if ~isempty(str)
%                 set(ui_triggerchannel,'string',str);
%                 if ~isempty(triggernbr)
%                     set(ui_triggerchannel,'Value',triggernbr);
%                 else
%                     set(ui_triggerchannel,'Value',1);
%                 end
%                 triggerchannel_callback();
%                 set(ui_triggerchannel,'Visible','on');
%             else
%                 set(ui_triggerchannel,'Visible','off');
%             end
%         end
    end

    function filter_callback(src,~)
        set_visible(0);
        val = str2double(get(src,'string'));
        switch src
            case ui_smoothing_width
                obj.signal.filter.smoothing_width = val;
            case ui_artifact_width
                obj.signal.filter.artifact_width = val;
            otherwise
                error('debugging error: incorrect option');
        end
        obj.has_unsaved_changes = true;
    end

    function waveform_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        str = get(ui_waveform,'string');
        val = get(ui_waveform,'val');
        tag = str{val};
        obj.waveform = obj.signal.waveforms.get('tag',tag);
    end

    function new_waveform_callback(~,~)
        obj.zoom_on = false; obj.pan_on = false;
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        dlg = figure;
        set(dlg,'windowstyle','modal');
        setheight(dlg,60);
        setwidth(dlg,200);
        dlgmgr = ScLayoutManager(dlg);
        dlgmgr.newline;
        dlgmgr.add(getuitext(['Signal: ' obj.signal.tag]),200);
        dlgmgr.newline;
        dlgmgr.add(getuitext('Name:'),40);
        ui_waveform_tag = dlgmgr.add(uicontrol('style','edit','string',...
            [],'horizontalalignment','left'),160);
        
        dlgmgr.newline;
        dlgmgr.add(uicontrol('style','pushbutton','string',...
            'Add','callback',@add_waveform_callback),100);
        
        function add_waveform_callback(~,~)
            tag = deblank(get(ui_waveform_tag,'string'));
            if ~isempty(tag) && ~obj.signal.waveforms.has('tag',tag)
                obj.signal.waveforms.add(ScWaveform(obj.signal,tag,[]));
                set(obj.waveformpanel,'Visible','on');
                signal_callback;
                obj.has_unsaved_changes = true;
                resize_fcn = get(obj.current_view,'ResizeFcn');
                resize_fcn();
            else
                msgbox(['Waveform name must be non-empty and unique for '...
                    'signal ' obj.signal.tag '.']);
            end
            close(dlg);
        end
        dlgmgr.add(uicontrol('style','pushbutton','string',...
            'Cancel','callback',@cancel_callback),100);
        
        function cancel_callback(~,~)
            close(dlg);
        end
        
    end

    function triggerchannel_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        obj.sweep = 1;
        str = get(ui_triggerchannel,'String');
        val = get(ui_triggerchannel,'Value');
        tag = str{val};
        triggerchannel = obj.sequence.gettriggerchannels(obj.tmin,obj.tmax).get('tag',tag);
        if triggerchannel.istrigger
            obj.trigger = triggerchannel;
            %             set(ui_removestims,'string',h.trigger.removestims);
            %             set(ui_removestims,'Visible','on');
            %             set(ui_trigger,'Visible','off');
        else
            %            set(ui_removestims,'Visible','off');
            set(ui_trigger,'string',triggerchannel.triggers.values('tag'));
            set(ui_trigger,'value',1);
            trigger_callback();
            set(ui_trigger,'Visible','on');
        end
    end

    function trigger_callback(~,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        obj.sweep = 1;
        str = get(ui_trigger,'String');
        val = get(ui_trigger,'Value');
        tag = str{val};
        obj.trigger = triggerchannel.triggers.get('tag',tag);
    end

    function extrasignal_callback(src,i)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        val = get(src,'Value');
        str = get(src,'string');
        tag = str{val};
        signal = obj.sequence.signals.get('tag',tag);
        obj.extrasignalaxes.get(i).signal = signal;
    end

    function range_callback(src,~)
        if obj.plot_waveform_shapes
            set_visible(0);
        end
        val = str2double(get(src,'string'));
        switch src
            case ui_pretrigger
                obj.pretrigger = val;
            case ui_posttrigger
                obj.posttrigger = val;
            otherwise
                error('debugging error : unkown option')
        end
    end

    function plot_waveforms_callback(~,~)
        set_visible(0);
        obj.plot_waveform_shapes = get(ui_plot_waveforms,'Value');
    end

    function load_callback(~,~)
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        obj.pretrigger = str2double(get(ui_pretrigger,'string'));
        obj.posttrigger = str2double(get(ui_posttrigger,'string'));
        if obj.pretrigger>=obj.posttrigger
            msgbox('Error: pre trigger >= post trigger');
            return
        end
        if obj.no_trigger
            if obj.signal.N>obj.max_array_size
                msgbox('More than maximum allowed array size.');
                return
            end
            if obj.pretrigger>0 || obj.pretrigger>=obj.posttrigger || ...
                    obj.posttrigger<=0
                msgbox(['Plotting in ''no trigger'' mode requires that ' ...
                    'pretrigger <= 0 < posttrigger']);
                return
            end
            obj.trigger = ScSpikeTrain('',...
                obj.sequence.tmin-obj.pretrigger:(obj.posttrigger-obj.pretrigger):...
                obj.sequence.tmax);
        end
        if obj.state == ScGuiState.spike_detection
            obj.waveform = obj.waveform;
        elseif obj.state == ScGuiState.ampl_analysis
            obj.ampl = obj.ampl;
        end
        obj.v_raw = obj.signal.sc_loadsignal();
        obj.v = obj.signal.filter.filt(obj.v_raw,0,inf);
        obj.plot_raw = get(ui_plot_raw,'Value');
        if ~obj.plot_raw
            obj.v_raw = [];
        end
        if obj.plot_waveform_shapes
            t = (0:(numel(obj.v)-1))';
            pos = t>=(round(obj.tmin/obj.signal.dt)+1) & ...
                t<(round(obj.tmax/obj.signal.dt)+1);
            clear t;
            if ~isempty(obj.waveform)
                [~,ind] = obj.waveform.match(obj.v(pos));
                obj.wfpos = ind>0;
            else
                obj.wfpos = false(nnz(pos),1);
            end
        else
            obj.wfpos = [];
        end
        maxsweeps = numel(obj.triggertimes);
        obj.sweep = obj.sweep(obj.sweep<=maxsweeps);
        obj.update_plotpanel_fcn();
        obj.update_histogrampanel_fcn();
        obj.update_savepanel_fcn();
        
        obj.plot_fcn();
        obj.disable_all(0);
        set_visible(1);
        obj.sweep = 1;
    end

    function set_visible(on)
        if ~layout_done
            return
        end
        if on
            visible = 'on';
        else
            visible = 'off';
        end
        set(obj.plotpanel,'visible',visible);
        set(obj.waveformpanel,'visible',visible);
    end
end