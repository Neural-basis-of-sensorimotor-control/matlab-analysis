function create_new_amplitude(obj)

dlg = figure;
set(dlg,'windowstyle','modal');
setwidth(dlg,200);
dlgmgr = ScLayoutManager(dlg);
dlgmgr.newline;
dlgmgr.add(getuitext(['Signal: ' obj.main_signal.tag]),200);
dlgmgr.newline(20);
triggers = obj.sequence.gettriggers(obj.sequence.tmin,obj.sequence.tmax);
if ~triggers.n
    msgbox('No available triggers')
    return
end
dlgmgr.add(sc_ctrl('text','Trigger'),100);
ui_trigger = dlgmgr.add(sc_ctrl('popupmenu',triggers.values('tag')),100);
dlgmgr.newline(5)
dlgmgr.newline(20);
dlgmgr.add(getuitext('Name:'),40);
ui_amplitude_tag = dlgmgr.add(sc_ctrl('edit',[],[],'horizontalalignment','left'),160);
dlgmgr.newline(5)
dlgmgr.newline(20);
dlgmgr.add(uicontrol('style','pushbutton','string','Add','callback',...
    @add_amplitude_callback),100);
uicontrol(ui_amplitude_tag);

    function add_amplitude_callback(~,~)
        tag = deblank(get(ui_amplitude_tag,'string'));
        ampls = obj.main_signal.amplitudes;
        if ~isempty(tag) && ~sc_contains(ampls.values('tag'),tag)
            str = get(ui_trigger,'string');
            val = get(ui_trigger,'value');
            trigger = triggers.get('tag',str{val});
            ampl = ScAmplitude(obj.sequence,obj.main_signal,trigger,...
                {'t1','v1','t2','v2'},tag);
            ampls.add(ampl);
            obj.set_amplitude(ampl);
            obj.has_unsaved_changes = true;
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

dlgmgr.newline(2);
dlgmgr.trim;
% 
% figmgr = ScLayoutManager(dlg);
% setheight(dlg,getheight(panel));
% figmgr.newline(getheight(panel));
% figmgr.add(panel);
% figmgr.trim;

end