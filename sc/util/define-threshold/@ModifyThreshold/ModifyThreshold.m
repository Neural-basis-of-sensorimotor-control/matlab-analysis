classdef ModifyThreshold < DefineThreshold
  
  methods (Access = 'public')
    
    varargout = sc_save(varargin)
    varargout = plot_starting_point(varargin)
    varargout = update_threshold(varargin)
    
  end
  
  properties
    
    threshold
    signal
    threshold_has_been_plotted
    
  end
  
  methods
    
    function obj = ModifyThreshold(h_axes, signal, threshold)
      
      obj@DefineThreshold(h_axes);
      
      if isneuron(signal)  
        signal = sc_load_signal(signal);
      end
      
      obj.signal                     = signal;
      obj.threshold                  = threshold;
      obj.threshold_has_been_plotted = false;
      
    end
    
  end
  
end
   
      
      
      