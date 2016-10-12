function create_new_waveform(obj)

obj.zoom_on = false; obj.pan_on = false;
dlg = figure;
set(dlg,'windowstyle','modal');
setheight(dlg,60);
setwidth(dlg,200);
dlgmgr = ScLayoutManager(dlg);
dlgmgr.newline;
dlgmgr.add(getuitext(['Signal: ' obj.main_signal.tag]),200);
dlgmgr.newline;
dlgmgr.add(getuitext('Name:'),40);
ui_waveform_tag = dlgmgr.add(sc_ctrl('edit',[],[],'horizontalalignment','left'),160);

dlgmgr.newline;
dlgmgr.add(uicontrol('style','pushbutton','string','Add','callback',...
  @add_waveform_callback),100);
uicontrol(ui_waveform_tag);

  function add_waveform_callback(~,~)
    tag = deblank(get(ui_waveform_tag,'string'));
    if ~isempty(tag) && ~obj.main_signal.waveforms.has('tag',tag)
      waveform = ScWaveform(obj.main_signal,tag,[]);
      obj.main_signal.waveforms.add(waveform);
      obj.waveform = waveform;
      obj.has_unsaved_changes = true;
      resize_fcn = get(obj.plot_window,'SizeChangedFcn');
      resize_fcn();
    else
      msgbox(['Waveform name must be non-empty and unique for '...
        'signal ' obj.main_signal.tag '.']);
      end
      close(dlg);
    end

  dlgmgr.add(uicontrol('style','pushbutton','string',...
    'Cancel','callback',@cancel_callback),100);

    function cancel_callback(~,~)
      close(dlg);
    end

  end
