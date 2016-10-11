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
      
      start = sc_get_amplitude_pseudo_start(amplitude);
      stop = sc_get_amplitude_pseudo_stop(obj.gui, amplitude);
      is_pseudo = sc_is_amplitude_data_pseudo(amplitude);
      rise = sc_get_amplitude_pseudo_rise(obj.gui, start, ...
        stop, is_pseudo, amplitude);
      middle = sc_get_middle_index(rise, .1);
      
      plot(obj.ax, start(~is_pseudo), rise(~is_pseudo), 'y+', 'Tag', 'Manual', 'LineStyle', 'None');
      plot(obj.ax, start(is_pseudo), rise(is_pseudo), 'r+', 'Tag', 'Automatic', 'LineStyle', 'None');
      plot(obj.ax, start(~middle), rise(~middle), 'wo', 'Tag', 'Outliers', 'LineStyle', 'None');
        
      h = add_legend(obj.ax);
      set(h, 'TextColor', 'w');
    end
  end
  
  
end