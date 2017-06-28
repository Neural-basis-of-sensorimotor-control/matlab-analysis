classdef AmplitudeSelection < PanelComponent
  properties
    ui_amplitude
  end
  methods
    function obj = AmplitudeSelection(panel)
      obj@PanelComponent(panel);
    end
    function populate(obj,mgr)
      mgr.newline(20);
      mgr.add(sc_ctrl('text','Amplitude'),100);
      mgr.newline(20);
      obj.ui_amplitude = mgr.add(sc_ctrl('popupmenu',[],...
        @(~,~) obj.amplitude_callback,'visible','off'),200);
      mgr.newline(5);
      mgr.newline(20);
      mgr.add(sc_ctrl('pushbutton','Add new amplitude',@(~,~) obj.create_new_amplitude),200);
      mgr.newline(20);
      mgr.add(sc_ctrl('pushbutton','Delete amplitude',@(~,~) obj.delete_amplitude),200);
      sc_addlistener(obj.gui,'amplitude',@(~,~) obj.amplitude_listener(),obj.panel);
    end
    function initialize(obj)
      obj.amplitude_listener();
    end
    function updated = update(obj)
      updated = ~isempty(obj.gui.amplitude);
    end
  end
  methods (Access = 'private')
    function amplitude_callback(obj)
      val = get(obj.ui_amplitude,'value');
      str = get(obj.ui_amplitude,'string');
      obj.gui.set_amplitude(obj.gui.main_signal.amplitudes.get('tag',str{val}));
      obj.show_panels(false);
    end
    function amplitude_listener(obj)
      if ~isempty(obj.gui.amplitude)
        str = obj.gui.main_signal.amplitudes.values('tag');
        val = sc_cellfind(str,obj.gui.amplitude.tag);
        set(obj.ui_amplitude,'string',str,'value',val,'visible','on');
      else
        set(obj.ui_amplitude,'visible','off');
      end
    end
    function create_new_amplitude(obj)
      obj.gui.create_new_amplitude();
    end
    function delete_amplitude(obj)
      if ~isempty(obj.gui.amplitude)
        answ = questdlg(sprintf('Do you really want to delete amplitude ''%s'' ? All data will be lost',obj.gui.amplitude.tag));
        if ~isempty(answ) && strcmp(answ,'Yes')
          obj.gui.main_signal.amplitudes.remove(obj.gui.amplitude);
          obj.panel.update_panel();
        end
      end
    end
  end
end
