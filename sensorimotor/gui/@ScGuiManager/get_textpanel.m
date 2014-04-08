function panel = get_textpanel(obj)

panel = uipanel('Title','Help');
setwidth(panel,obj.leftpanelwidth);
mgr = ScLayoutManager(panel);
mgr.newline(15);
mgr.newline(40);
ui_text = mgr.add(sc_ctrl('text','','Value',2),obj.leftpanelwidth);
sc_addlistener(obj,'text',@text_listener,ui_text);

    function text_listener(~,~)
        set(ui_text,'string',obj.text);
    end

mgr.newline(2);
mgr.trim;

end