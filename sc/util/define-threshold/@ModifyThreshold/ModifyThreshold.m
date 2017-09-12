classdef ModifyThreshold < DefineThreshold
  
  methods (Access = 'public')
    
    varargout = sc_save(varargin)
    varargout = export_to_threshold(varargin)
    varargout = plot_starting_point(varargin)
    
  end
  
  properties
    
    threshold
    signal
    
  end
  
  methods
    
    function obj = ModifyThreshold(h_axes, signal, threshold)
      
      obj@DefineThreshold(h_axes);
      
      if isneuron(signal)  
        signal = sc_load_signal(signal);
      end
      
      obj.signal    = signal;
      obj.threshold = threshold;
      
    end
    
  end
  
end
   
      
      
      