function panel = get_filepanel(obj)

panel = uipanel('title',['File: ' obj.file.tag]);
obj.filepanel = panel;
mgr = ScLayoutManager(panel);
mgr.newline(15);

%Up one step
mgr.newline(20);
mgr.add(uicontrol('style','pushbutton','string','Select sequence','callback',...
    @select_sequence_callback,'ToolTipString','Open previous menu'),100);

%File/sequence info
mgr.add(getuitext([obj.sequence.tag ' time: ' num2str(round(obj.sequence.tmin)) ...
    ' - ' num2str(round(obj.sequence.tmax))]),100); 
ui_comment = uicontrol('style','text','string',obj.sequence.comment,...
    'HorizontalAlignment','left','Max',2);
nbrofrows = numel(strfind(obj.sequence.comment,sprintf('\n')))+1;
setheight(ui_comment,nbrofrows*20);
setwidth(ui_comment,obj.leftpanelwidth);
mgr.addobject(ui_comment);

mgr.newline(20);
mgr.add(uicontrol('style','pushbutton','String','Screenshot (JPEG)',...
    'Callback',@make_screenshot_callback),100);
mgr.add(uicontrol('style','pushbutton','String','Settings','Callback',...
    @settings_callback),100);
   
if 0
    mgr.newline(20);
    mgr.add(getuitext('Number of plots'),80);
    
    %Reset number of extra signal axes if more than available in sequence
    if h.extrasignalaxes.n+1>h.sequence.signals.n
        h.extrasignalaxes = ScList();
    end
    mgr.add(uicontrol('style','popupmenu','string',1:h.sequence.signals.n,...
        'Value',h.extrasignalaxes.n+1,'Callback',...
        @nbr_of_plotaxes_callback),80);
end

mgr.newline(20);
mgr.add(uicontrol('style','pushbutton','String','Spike detection','Callback',...
    @spike_detection_callback),obj.leftpanelwidth/2);

    function spike_detection_callback(~,~)
        obj.state = ScGuiState.spike_detection;
        load_callback();
        obj.text = {'Choose signal, trigger, waveform etc. Then press ''Load signal'',',...
            'or use histogram panel below'};
    end

mgr.add(uicontrol('style','pushbutton','String','Amplitude analysis','Callback',...
    @ampl_analysis_callback),obj.leftpanelwidth/2);

    function ampl_analysis_callback(~,~)
        obj.state = ScGuiState.ampl_analysis;
        load_callback();
        obj.text = 'Choose Amplitude or create new. Then press ''Load signal''';
    end

mgr.newline(2);
mgr.trim;

    function load_callback(~,~)
    %    clf(h.current_view);
    %    h.state = h.state;
        show_sequence(obj);
    end

    function select_sequence_callback(~,~)
        clf(obj.current_view,'reset');
        show_file(obj);
    end
    function make_screenshot_callback(~,~)
        [fname,pname] = uiputfile('*.jpeg','Save screenshot as');
        if isnumeric(fname),    return; end
        set(obj.current_view, 'InvertHardCopy', 'off');
        set(obj.current_view,'PaperPositionMode','auto')
        print(obj.current_view,'-djpeg100',fullfile(pname,fname))
    end

    function nbr_of_plotaxes_callback(src,~)
        obj.extrasignalaxes = ScList();
        for i=1:get(src,'Value')-1
            obj.extrasignalaxes.add(ScSignalAxesHandle());
        end
        set_visible(0);
    end

    function settings_callback(~,~)
        triggers = obj.file.gettriggers(obj.tmin,obj.tmax);
        dlg = figure();
        set(dlg,'windowStyle','modal','Name','Add sequence');
        setwidth(dlg,355);
        setheight(dlg,20*(triggers.n+2)+2);
        sety(dlg,getheight(obj.current_view)-getheight(dlg)-20);
        dialogmgr = ScLayoutManager(dlg);
        ui_triggers = nan(triggers.n,1);
        if triggers.n>numel(obj.show_triggers)
            obj.show_triggers(end+1:triggers.n) = true(triggers.n-numel(obj.show_triggers),1);
        end
        for k=1:triggers.n
            dialogmgr.newline(20);
            ui_triggers(k) = dialogmgr.add(uicontrol('style','checkbox','String',...
                triggers.get(k).tag,'Value',obj.show_triggers(k),...
                'callback',@(src,~) update_show_triggers(src,k)),350);
        end
        dialogmgr.newline(20);
        ui_select_all = dialogmgr.add(uicontrol('style','checkbox','String',...
            'Select / deselect all','Value',1,...
            'callback',@(src,~) update_show_triggers(src,1:triggers.n)),350);
        dialogmgr.newline(20);
        dialogmgr.add(uicontrol('style','pushbutton','String',...
            'Done','callback',@(~,~) close(dlg)),350);
        dialogmgr.newline(2);
        dialogmgr.trim;
        
        function update_show_triggers(src, triggernbr)
            value = get(src,'value');
            obj.show_triggers(triggernbr) = value*ones(numel(triggernbr),1);
            if src == ui_select_all
                for i=1:triggers.n
                    set(ui_triggers(i),'value',obj.show_triggers(i));
                end
            end
        end
        
    end

    function set_visible(on)
        if on
            visible = 'on';
        else
            visible = 'off';
        end
        set(obj.triggerpanel,'Visible',visible);
        set(obj.plotpanel,'Visible',visible);
        set(obj.waveformpanel,'Visible',visible);
        set(obj.waveformpanel,'Visible',visible);
    end
end