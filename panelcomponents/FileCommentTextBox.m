classdef FileCommentTextBox < PanelComponent
  properties
    ui_text
  end
  
  methods
    
    function obj = FileCommentTextBox(panel)
      obj@PanelComponent(panel);
    end
    
    
    function populate(obj,mgr)
      mgr.newline(40);
      obj.ui_text = mgr.add(sc_ctrl('edit',[],@(~,~) obj.text_callback(),...
        'Value',2,'HorizontalAlignment','left','Max',2),200);
      sc_addlistener(obj.gui,'file',@(~,~) obj.file_listener,obj.uihandle);
    end
    
    
    function initialize(obj)
      obj.file_listener();
    end
    
  end
  
  methods (Access = 'private')
    
    function file_listener(obj)
      
      if isempty(obj.gui.file)
        set(obj.ui_text,'string',[]);
      else
        set(obj.ui_text,'string',obj.gui.file.user_comment,'BackgroundColor',[1 1 .9],...
          'ForegroundColor',[0 0 0]);
      end
    end
    
    
    function text_callback(obj)
      obj.gui.file.user_comment = get(obj.ui_text,'string');
      obj.gui.has_unsaved_changes = true;
    end
  end
end
