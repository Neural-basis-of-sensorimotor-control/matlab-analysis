classdef PlotOptions < PanelComponent
  properties
    ui_plot_raw
    ui_plot_waveforms
  end
  methods
    function obj = PlotOptions(panel)
      obj@PanelComponent(panel);
    end

    function populate(obj,mgr)
      mgr.newline(20);
      obj.ui_plot_raw = mgr.add(sc_ctrl('checkbox','Plot raw data',@(~,~) plot_raw_callback(obj),...
        'value',obj.gui.main_channel.plot_raw),200);
      mgr.newline(5);
      mgr.newline(20);
      obj.ui_plot_waveforms = mgr.add(sc_ctrl('checkbox','Plot waveforms',@(~,~) plot_waveforms_callback(obj),...
        'value',obj.gui.main_channel.plot_waveforms),200);
      mgr.newline(5);

      function plot_raw_callback(objh)
        objh.gui.main_channel.plot_raw = get(objh.ui_plot_raw,'value');
        objh.show_panels(false);
        objh.automatic_update();
      end

      function plot_waveforms_callback(objh)
        objh.gui.main_channel.plot_waveforms = get(objh.ui_plot_waveforms,'value');
        objh.show_panels(false);
        objh.automatic_update();
      end
    end
  end
end
