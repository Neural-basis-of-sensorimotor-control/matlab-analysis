classdef ScTriggerPanel < sc_viewer.ScViewerComponent
  
  properties
    
    ui_trigger_time
    ui_trigger_parent
    ui_trigger_tag
    ui_trigger_indx
    ui_tot_trigger_nbr
    ui_trigger_increment
    ui_pretrigger
    ui_posttrigger
    
  end
  
  methods (Static)
    
    function ui_panel = get_panel(viewer)
      
      ui_panel = uipanel(viewer.button_window, 'Title', 'Trigger');
      panel    = sc_viewer.ScTriggerPanel(ui_panel, viewer);
      mgr      = sc_layout.PanelLayoutManager(ui_panel);
      
      mgr.add(sc_ctrl('text', 'Trigger parent'), 100);
      panel.ui_trigger_parent = mgr.add(sc_ctrl('popupmenu', [], ...
        @(~,~) panel.trigger_parent_callback(), 'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Trigger tag'), 100);
      panel.ui_trigger_tag = mgr.add(sc_ctrl('popupmenu', [], ...
        @(~,~) panel.trigger_tag_callback(), 'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Trigger #'), 100);
      panel.ui_trigger_indx = mgr.add(sc_ctrl('edit', [], ...
        @(~,~) panel.trigger_indx_callback(), 'Visible', 'off'), 100);
      mgr.newline();
      
      panel.ui_tot_trigger_nbr = mgr.add(sc_ctrl('text', ''), 200);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'trigger_increment'), 100);
      panel.ui_trigger_increment = mgr.add(sc_ctrl('edit', [], ...
        @(~,~) panel.trigger_increment_callback(), 'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('pushbutton', '-', ...
        @(~,~) panel.backwd_callback()), 100);
      
      mgr.add(sc_ctrl('pushbutton', '+', ...
        @(~,~) panel.fwd_callback()), 100);
      
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Time'), 100);
      panel.ui_trigger_time = mgr.add(sc_ctrl('edit', '', ...
        @(~,~) panel.trigger_time_callback()), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Pretrigger'), 100);
      panel.ui_pretrigger = mgr.add(sc_ctrl('edit', '', ...
        @(~,~) panel.pretrigger_callback), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Posttrigger'), 100);
      panel.ui_posttrigger = mgr.add(sc_ctrl('edit', '', ...
        @(~,~) panel.posttrigger_callback()), 100);
      mgr.newline();
      
      mgr.trim();
      
      panel.trigger_parent_listener();
      panel.trigger_tag_listener();
      panel.trigger_time_listener();
      panel.pretrigger_listener();
      panel.posttrigger_listener();
      
      sc_addlistener(panel.viewer, 'trigger_parent', @(~,~) panel.trigger_parent_listener, ui_panel);
      sc_addlistener(panel.viewer, 'trigger_tag', @(~,~) panel.trigger_tag_listener, ui_panel);
      sc_addlistener(panel.viewer, 'trigger_time', @(~,~) panel.trigger_time_listener, ui_panel);
      sc_addlistener(panel.viewer, 'pretrigger', @(~,~) panel.pretrigger_listener, ui_panel);
      sc_addlistener(panel.viewer, 'posttrigger', @(~,~) panel.posttrigger_listener, ui_panel);
    
    end
    
  end
  
  methods
    
    function obj = ScTriggerPanel(panel, viewer)
      obj@sc_viewer.ScViewerComponent(panel, viewer);
    end
    
  end
  
  methods (Access = protected)
    
    function trigger_parent_listener(obj)
      
      triggables = obj.viewer.file.get_triggables();
      str = get_values(triggables, 'tag');
      str = add_to_list(str, '#none');
      
      if isempty(obj.viewer.trigger_parent)
        indx = length(str);
      else
        indx = find(cellfun(@(x) x == obj.viewer.trigger_parent, triggables));
      end
      
      set(obj.ui_trigger_parent, 'String',str, 'Value', indx, ...
        'Visible', 'on');
      
    end
    
    
    function trigger_tag_listener(obj)
      
      if isempty(obj.viewer.trigger_tag)
        
        set(obj.ui_trigger_tag, 'Visible', 'off');
        return
        
      end
      
      str = obj.viewer.trigger_parent.get_tags();
      indx = find(cellfun(@(x) strcmp(x, obj.viewer.trigger_tag), str));
      
      set(obj.ui_trigger_tag, 'String', str, ...
        'Value', indx, 'Visible', 'on');
      
    end
    
    
    function trigger_time_listener(obj)
      
      set(obj.ui_trigger_time, 'String', obj.viewer.trigger_time);
      
    end
    
    
    function pretrigger_listener(obj)
      
      set(obj.ui_trigger_time, 'String', obj.viewer.pretrigger);
      
    end
    
    
    function posttrigger_listener(obj)
      
      set(obj.ui_trigger_time, 'String', obj.viewer.pretrigger);    
    
    end
    
    
    function trigger_parent_callback(obj)
      
      indx = get(obj.ui_trigger_parent, 'Value');
      triggables = obj.viewer.file.get_triggables();
      
      if indx > length(triggables)
        obj.viewer.set_trigger_parent([]);
      else
        obj.viewer.set_trigger_parent(triggables{indx});
      end
      
    end
    
    
    function trigger_tag_callback(obj)
      
      indx = get(obj.ui_trigger_parent, 'Value');
      tags = obj.viewer.trigger_parent.get_tags();
      obj.viewer.set_trigger_tag(tags{indx});
      
    end
    
  end
  
end