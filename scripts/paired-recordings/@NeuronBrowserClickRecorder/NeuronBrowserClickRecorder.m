classdef NeuronBrowserClickRecorder < ClickRecorder
  
  methods
    varargout = add_point(varargin)
  end
  
  properties
    
    neurons
    neuron
    neuron_pair_indx
    
  end
  
  methods
    
    function obj = NeuronBrowserClickRecorder(neurons)
      
      obj@ClickRecorder(gca, 20);
      obj.neurons          = neurons;
      obj.neuron           = obj.neurons(1);
      obj.neuron_pair_indx = 1;
      
    end
    
  end
  
end