classdef AmplitudeAverageChannel < SubplotChannel
  
  properties
    subplot_index = 2
  end
  
  methods
    
    function obj = AmplitudeAverageChannel(gui)
      obj@SubplotChannel(gui);
    end
    
    function plot_channel(obj)
      cla(obj.ax);
      hold(obj.ax, 'on');
      
      amplitude = obj.gui.amplitude;
      
      if isempty(amplitude)
        return
      end
      
      pretrigger = obj.gui.pretrigger;
      posttrigger = obj.gui.posttrigger;
      dt = amplitude.parent_signal.dt;
            
      [vv, t] = sc_get_sweeps(obj.gui.main_channel.v, 0, ...
        amplitude.stimtimes, pretrigger, posttrigger, dt);
      
      for i=1:size(vv,2)
        plot(obj.ax, t, vv(:,i), 'r');
      end
      
      plot(obj.ax, t, median(vv, 2), 'b', 'LineWidth', 2);
      xlabel(obj.ax, 'Time [s]', 'Color', 'w');
      ylabel(obj.ax, 'Amplitude [mV]', 'Color', 'w');
    end
  end
end
