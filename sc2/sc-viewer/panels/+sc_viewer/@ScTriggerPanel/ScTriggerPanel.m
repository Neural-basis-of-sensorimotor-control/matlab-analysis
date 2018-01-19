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
      
      ui_panel = uipanel(viewer.button_window, 'Title', 'Experiment');
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
      
      mgr.add(sc_ctrl('text', 'Trigger #'), 100);
      panel.ui_trigger_indx = mgr.add(sc_ctrl('edit', [], ...
        @(~,~) panel.trigger_indx_callback(), 'Visible', 'off'), 100);
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
      
      sc_addlistener(viewer, 'trigger_parent', ...
        @(~,~) panel.trigger_parent_listener(), ui_panel);
      
      sc_addlistener(viewer, 'trigger_tag', ...
        @(~,~) panel.trigger_tag_listener(), ui_panel);
      
      sc_addlistener(viewer, 'trigger_time', ...
        @(~,~) panel.trigger_time_listener(), ui_panel);
      
      sc_addlistener(viewer, 'pretrigger', ...
        @(~,~) panel.pretrigger_listener(), ui_panel);
      
      sc_addlistener(viewer, 'posttrigger', ...
        @(~,~) panel.posttrigger_listener(), ui_panel);
      
      sc_addlistener(viewer, 'trigger_increment', ...
        @(~,~) panel.incremnent_listener(), ui_panel);
      
      panel.trigger_parent_listener();
      panel.trigger_tag_listener();
      panel.trigger_time_listener();
      panel.pretrigger_listener();
      panel.posttrigger_listener();
      
    end
    
  end
  
  methods
    
    function obj = ScTriggerPanel(panel, viewer)
      obj@sc_viewer.ScViewerComponent(panel, viewer);
    end
    
  end
  
  methods (Access = protected)
    
    function trigger_parent_listener(obj)
      error('Not implemented');
    end
    
    
    function trigger_tag_listener(obj)
      error('Not implemented');
    end
    
    
    function trigger_time_listener(obj)
      error('Not implemented');
    end
    
    
    function pretrigger_listener(obj)
      error('Not implemented');
    end
    
    
    function posttrigger_listener(obj)
      error('Not implemented');
    end
    
  end
  
end