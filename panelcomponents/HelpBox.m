classdef HelpBox < PanelComponent
   properties
       ui_text
   end
   methods
       function obj = HelpBox(panel)
           obj@PanelComponent(panel);
           sc_addlistener(obj.gui,'help_text',@(~,~) obj.initialize,obj.uihandle);
       end
       function populate(obj,mgr)
           mgr.newline(20);
           obj.ui_text = mgr.add(sc_ctrl('text',[]),200);
           addlistener(obj.ui_text,'Enable','PostSet',@(src,~) set(src,'Enable','on'));
       end
       function initialize(obj)
           set(obj.ui_text,'string',obj.gui.help_text);
       end
   end
end