classdef PlotAmplitude < PanelComponent
  properties
    ui_clear_sweep
    ui_nbr_of_triggers
  end
  methods
    function obj = PlotAmplitude(panel)
      obj@PanelComponent(panel);
    end
    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_clear_sweep = mgr.add(sc_ctrl('pushbutton','Clear sweep',...
        @(~,~) obj.clear_sweep_callback()),200);
      mgr.newline(20);
      obj.ui_nbr_of_triggers = mgr.addsc('text',[],200);

      sc_addlistener(obj.gui,'mouse_press',@(~,~) obj.mouse_press_listener,...
        obj.ui_clear_sweep);
      sc_addlistener(obj.gui,'amplitude',@(~,~) obj.amplitude_listener(),...
        obj.ui_nbr_of_triggers);
      end
    end
    methods (Access = 'private')
      function clear_sweep_callback(obj)
        obj.gui.has_unsaved_changes = true;
        stimtime = obj.gui.triggertimes(obj.sweep(1));
        obj.gui.amplitude.add_data(stimtime,1:4,nan(4,1));
        obj.gui.set_mouse_press(1);
        obj.gui.plot_channels();
      end
      function mouse_press_listener(obj)
        if obj.gui.mouse_press == 0 || obj.gui.mouse_press == 2
          set(obj.ui_clear_sweep,'visible','on');
        else
          set(obj.ui_clear_sweep,'visible','off');
        end
      end
      function amplitude_listener(obj)
        if isempty(obj.gui.amplitude)
          set(obj.ui_nbr_of_triggers,'string',[]);
        else
          set(obj.ui_nbr_of_triggers,'string',...
            sprintf('Total sweeps: %i',numel(obj.gui.triggertimes)));
          end
        end
      end
    end
