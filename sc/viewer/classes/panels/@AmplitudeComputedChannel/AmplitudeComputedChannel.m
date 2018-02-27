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

      start = intra_get_amplitude_pseudo_start(amplitude);
      stop = intra_get_amplitude_pseudo_stop(amplitude, obj.gui.main_channel.v);
      is_pseudo = ~amplitude.valid_data;
      rise = intra_get_amplitude_pseudo_rise(start, stop, is_pseudo, ...
        amplitude, obj.gui.main_channel.v);
      middle = intra_get_middle_index(rise, .1);

      plot(obj.ax, start(~is_pseudo), rise(~is_pseudo), 'y+', 'Tag', 'Manual', 'LineStyle', 'None');
      plot(obj.ax, start(is_pseudo), rise(is_pseudo), 'r+', 'Tag', 'Automatic', 'LineStyle', 'None');
      plot(obj.ax, start(~middle), rise(~middle), 'wo', 'Tag', 'Outliers', 'LineStyle', 'None');

      h = add_legend(obj.ax);
      set(h, 'TextColor', 'w');
    end
  end


end
