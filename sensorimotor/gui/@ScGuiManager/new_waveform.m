function new_waveform(obj)

obj.zoom_on = false; obj.pan_on = false;
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
            if obj.plot_waveform_shapes
                set_visible(0);
            end
            obj.signal = obj.signal;
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