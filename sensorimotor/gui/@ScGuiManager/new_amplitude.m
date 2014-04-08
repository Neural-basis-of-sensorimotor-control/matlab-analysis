function new_amplitude(obj)

fig = figure('WindowStyle','modal');
panel = uipanel;
mgr = ScLayoutManager(panel);
mgr.newline(5);
mgr.newline(20);
mgr.add(sc_ctrl('text','Signal'),100);
ui_signal = mgr.add(sc_ctrl('popupmenu',obj.file.signals.values('tag')),200);
mgr.newline(20);
mgr.add(sc_ctrl('text','Trigger'),100);
ui_trigger = mgr.add(sc_ctrl('popupmenu',obj.file.gettriggers(obj.tmin,obj.tmax).values('tag')),200);
mgr.newline(20);
mgr.add(sc_ctrl('text','Tag'),100);
ui_tag = mgr.add(sc_ctrl('edit','ampl1'),200);
mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Create',@create_callback),100);

    function create_callback(~,~)
        tag = get(ui_tag,'string');
        if obj.sequence.ampl_list.has('tag',tag)
            msgbox('Name already in use. Choose another tag.');
        else
            obj.has_unsaved_changes = true;
            val = get(ui_signal,'value');
            str = get(ui_signal,'string');
            signal = obj.file.signals.get('tag',str{val});
            val = get(ui_trigger,'value');
            str = get(ui_trigger,'string');
            trigger = obj.file.gettriggers(obj.tmin,obj.tmax).get('tag',str{val});
            ampl = ScAmplitude(obj.sequence,signal,trigger,{'t1','v1','t2','v2'},tag);
            obj.sequence.ampl_list.add(ampl);
            obj.ampl = ampl;
            close(fig);
        end
    end

mgr.add(sc_ctrl('pushbutton','Cancel',@cancel_callback),100);

    function cancel_callback(~,~)
        close(fig);
    end

mgr.newline(2);
mgr.trim;

figmgr = ScLayoutManager(fig);
setheight(fig,getheight(panel));
figmgr.newline(getheight(panel));
figmgr.add(panel);
figmgr.trim;

end