function add_help_panel(obj)
panel = uipanel('title','Help','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);
mgr.newline(60);
ui_help = mgr.add(sc_ctrl('text',[]),200);
mgr.newline(2);
mgr.trim();
obj.panels.add(panel);

sc_addlistener(obj,'help',@help_callback,panel);

    function help_callback(~,~)
        set(ui_help,'string',obj.help);
    end
end
