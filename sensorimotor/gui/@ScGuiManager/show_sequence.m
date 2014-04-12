function show_sequence(obj)
%todo: this function could be split up into several functions, one for each
%possible value of obj.state
%Or ScGuiManager is made an inheritable abstract class, and one
%implementation is used for each state
if ~isempty(obj.current_view)
    clf(obj.current_view,'reset');
    set(obj.current_view,'ToolBar','None');
end

set(obj.current_view,'CloseRequestFcn',@(src,evt) sc_close_request(src,evt,obj),...
    'menubar','none','Color',[0 0 0]);

mgr = ScLayoutManager(obj.current_view);

add_to_left_panel(obj.get_textpanel);
add_to_left_panel(get_filepanel(obj));
add_to_left_panel(get_triggerpanel(obj));
add_to_left_panel(get_plotpanel(obj));
if obj.state == ScGuiState.spike_detection
    add_to_left_panel(get_waveformpanel(obj));
elseif obj.state == ScGuiState.ampl_analysis
    add_to_left_panel(get_amplitudepanel(obj));
end
add_to_left_panel(get_savepanel(obj));
add_to_left_panel(get_histogrampanel(obj));
get_plotaxes(obj);
if obj.state == ScGuiState.spike_detection
    set(obj.histogrampanel,'visible','on');
    set(obj.histogramaxes,'visible','on');
elseif obj.state == ScGuiState.ampl_analysis
    set(obj.histogrampanel,'visible','off');
    set(obj.histogramaxes,'visible','off');
end
obj.disable_all(1);

set(obj.current_view,'ResizeFcn',@resize_fcn);

resize_fcn;
obj.sequence = obj.sequence;
obj.disable_all(0);
obj.text = 'Choose ''Spike detection'' or ''Amplitude analysis''';

    function add_to_left_panel(panel)
        setwidth(panel,obj.leftpanelwidth);
        mgr.newline(getheight(panel));
        mgr.add(panel);
    end

    function resize_fcn(~,~)
        mgr.trim;
        width = getwidth(obj.current_view)-3*obj.borderwidth-obj.leftpanelwidth;
        setwidth(obj.stimaxes,width);
        setwidth(obj.signalaxes,width);
        for i=1:obj.extrasignalaxes.n
            setwidth(obj.extrasignalaxes.get(i).axeshandle,width);
        end
        setwidth(obj.histogramaxes,width);
        stimheight = nnz(obj.show_triggers)*15;
        stimheight = max(stimheight,15);
        setheight(obj.stimaxes,stimheight);      
        y = getheight(obj.current_view)-(getheight(obj.stimaxes)+obj.borderwidth/2);
        sety(obj.stimaxes,y);
        signalheight = getheight(obj.current_view) - (getheight(obj.stimaxes) + ...
            obj.borderwidth + 2*obj.borderwidth + getheight(obj.histogramaxes) + ...
            obj.extrasignalaxes.n*(obj.plotheight+obj.borderwidth));
        signalheight = max(signalheight,obj.plotheight);
        y = y - (signalheight + obj.borderwidth/2);
        sety(obj.signalaxes,y);
        setheight(obj.signalaxes,signalheight);
        y = y - obj.borderwidth;
        for i=1:obj.extrasignalaxes.n
            y = y - (obj.plotheight);
            sety(obj.extrasignalaxes.get(i).axeshandle,y);
            y = y - obj.borderwidth/2;
        end
        y = y - getheight(obj.histogramaxes);
        sety(obj.histogramaxes,y);
    end
end