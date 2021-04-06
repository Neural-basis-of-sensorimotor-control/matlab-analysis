classdef ImportTrigger < PanelComponent
  
  properties
    ui_remove_btn
  end
  
  methods
    
    function obj = ImportTrigger(panel)
      obj@PanelComponent(panel)
    end
    
    function populate(obj, mgr)
      mgr.newline(20)
      mgr.add(sc_ctrl('pushbutton', 'Import trigger', @(~, ~) obj.add_trigger_callback()), 200)
      mgr.newline(20)
      obj.ui_remove_btn = mgr.add(sc_ctrl('pushbutton', 'Remove imported trigger', @(~,~) obj.remove_trigger_callback()), 200);
      mgr.newline(5)
      sc_addlistener(obj.gui, 'file', @(~,~) obj.file_listener(), obj.ui_remove_btn);
    end
    
    function initialize(obj)
      obj.file_listener()
    end
    
  end
  
  methods (Access='protected')
    
    function file_listener(obj)
      if isempty(obj.gui.file)
        visible = 'off';
      else
        imported_triggers = obj.gui.file.imported_triggers;
        if ~isempty(imported_triggers) && imported_triggers.triggers.n > 0
          visible = 'on';
        else
          visible = 'off';
        end
      end
      set(obj.ui_remove_btn, 'Visible', visible)
    end
    
    function add_trigger_callback(obj)
      [fname, pathname] = uigetfile('*.csv', 'Select file with trigger data');
      if ~isnumeric(fname)
        [~, tag] = fileparts(fname);
        if ~isempty(obj.gui.file.imported_triggers)
          base = tag;
          counter = 1;
          while obj.gui.file.imported_triggers.triggers.has('tag', tag)
            counter = counter+1;
            tag = sprintf('%s_%d', base, counter);
          end
        end
        times = csvread(fullfile(pathname, fname));
        if ~isnumeric(times) || any(~isfinite(times))
          msgbox('Import failed: File contains non-numeric values.')
          return
        end
        scfile = obj.gui.file;
        if isempty(scfile.imported_triggers)
          scfile.imported_triggers = TriggerParent('Imported triggers');
        end
        scfile.imported_triggers.triggers.add(Trigger(tag, times))
        obj.gui.set_file(obj.gui.file)
        obj.file_listener()
        obj.gui.plot_channels();
      end
    end
    
    function remove_trigger_callback(obj)
      triggers = obj.gui.file.imported_triggers.triggers;
      fig = figure('WindowStyle', 'modal');
      figmanager = ScLayoutManager(fig);
      panel = uipanel('Parent',fig);
      mgr = ScLayoutManager(panel);
      mgr.newline(20);
      ui_triggers = mgr.add(sc_ctrl('popup', triggers.values('tag')), 200);
      mgr.newline(25);
      mgr.add(sc_ctrl('pushbutton', 'Remove', @(~,~) obj.remove_trigger(ui_triggers, fig)), 200);
      mgr.newline(20);
      mgr.add(sc_ctrl('pushbutton', 'Close', @(~,~) close(fig)), 200);
      mgr.newline(5)
      mgr.trim()
      figmanager.newline(getheight(panel))
      figmanager.add(panel)
      figmanager.trim()
    end
    
    function remove_trigger(obj, ui_triggers, fig)
      val = get(ui_triggers, 'Value');
      str = get(ui_triggers, 'String');
      strval = str{val};
      obj.gui.file.imported_triggers.triggers.remove('tag', strval)
      close(fig)
      obj.gui.set_file(obj.gui.file)
      obj.file_listener()
      obj.gui.plot_channels();
    end
    
  end
  
end