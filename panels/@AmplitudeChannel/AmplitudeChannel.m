classdef AmplitudeChannel < SubplotChannel

  methods (Abstract)
    plot_amplitude(obj)
  end

  methods

    function obj = AmplitudeChannel(gui)
      obj@SubplotChannel(gui);
    end

    function plot_channel(obj)      
      obj.plot_amplitude();

      %set(obj.ax, 'Color', 'k');
      xlabel(obj.ax, 'Latency [s]', 'Color', 'w');
      ylabel(obj.ax, 'Amplitude [mV]', 'Color', 'w');
    end
  end
end
