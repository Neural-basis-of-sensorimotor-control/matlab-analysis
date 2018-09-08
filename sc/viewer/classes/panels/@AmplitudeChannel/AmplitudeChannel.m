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

      xlabel(obj.ax, 'Time to peak [s]', 'Color', 'w');
      ylabel(obj.ax, 'Amplitude [mV]', 'Color', 'w');
    end
  end
end
