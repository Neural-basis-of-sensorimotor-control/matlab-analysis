classdef NeuronBrowserClickRecorder < ClickRecorder
  
  properties
    
    neurons
    neuron
    
  end
  
  methods
    
    function obj = NeuronBrowserClickRecorder(neurons)
      
      obj@ClickRecorder(gca, 20);
      obj.neurons = neurons;
      obj.neuron = obj.neurons(1);
      
    end
    
  end
  
end