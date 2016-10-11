classdef SaveLoadButton < PanelComponent
  %Save and Load experiment data
  properties
    ui_save
    ui_save_as
    ui_load
    ui_new_sp2
    ui_new_adq
  end
  methods
    function obj = SaveLoadButton(panel)
      obj@PanelComponent(panel);
    end
    
    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_save = mgr.add(sc_ctrl('pushbutton','Save',@(~,~) obj.save_callback),100);
      obj.ui_save_as = mgr.add(sc_ctrl('pushbutton','Save As',@(~,~) obj.save_as_callback),100);
      mgr.newline(20);
      obj.ui_load = mgr.add(sc_ctrl('pushbutton','Load',@(~,~) obj.load_callback),100);
      mgr.newline(20);
      obj.ui_new_sp2 = mgr.add(sc_ctrl('pushbutton','New Spike2 set',@(~,~) obj.new_sp2_set),100);
      obj.ui_new_adq = mgr.add(sc_ctrl('pushbutton','New .adq set',@(~,~) obj.new_adq_set),100);
      sc_addlistener(obj.gui,'has_unsaved_changes',@(~,~) obj.has_unsaved_changes_listener,obj.uihandle);
    end
  end
  methods (Access='protected')
    function save_callback(obj)
      obj.gui.experiment.last_gui_version = SequenceViewer.version_str;
      saved = obj.gui.experiment.sc_save(false);
      if saved
        obj.gui.has_unsaved_changes = false;
      end
    end
    
    function save_as_callback(obj)
      obj.gui.experiment.last_gui_version = SequenceViewer.version_str;
      saved = obj.gui.experiment.sc_save(true);
      if saved
        obj.gui.has_unsaved_changes = false;
      end
    end
    
    function load_callback(obj)
      mode = obj.gui.mode;
      gui_mgr = sc('-loadnew');
      
      if mode == ScGuiState.ampl_analysis
        gui_mgr.mode = ScGuiState.ampl_analysis;
      end
    end
    
    function new_sp2_set(~)
      sc -newsp2;
    end
    
    function new_adq_set(~)
      sc -newadq;
    end
    
    function has_unsaved_changes_listener(obj)
      if obj.gui.has_unsaved_changes
        set(obj.ui_save,'Enable','on');
      else
        set(obj.ui_save,'Enable','off');
      end
    end
  end
end