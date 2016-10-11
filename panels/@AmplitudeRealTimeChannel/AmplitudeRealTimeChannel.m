classdef AmplitudeRealTimeChannel < AmplitudeChannel
  
  properties
    subplot_index = 1
  end
  
  methods
    
    function obj = AmplitudeRealTimeChannel(gui)
      obj@AmplitudeChannel(gui);
    end
    
    function plot_amplitude(obj)
      amplitude = obj.gui.amplitude;
      plot(obj.ax, amplitude.latency, amplitude.rise_amplitude, 'y+', 'LineStyle', 'None')
    end
  end
end