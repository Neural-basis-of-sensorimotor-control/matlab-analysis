classdef AmplitudeComputedChannel < AmplitudeChannel

  properties
    subplot_index = 1
  end

  methods

    function obj = AmplitudeComputedChannel(gui)
      obj@AmplitudeChannel(gui);
    end

    function plot_amplitude(obj)
      amplitude = obj.gui.amplitude;
      cla(obj.ax)
      hold(obj.ax, 'on');

      if ~nnz(amplitude.valid_data)  
        return
      end
      plot(obj.ax, amplitude.width, amplitude.height, 'y+');
      h = add_legend(obj.ax);
      set(h, 'TextColor', 'w');
    end
  end


end
