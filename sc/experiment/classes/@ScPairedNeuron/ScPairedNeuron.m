classdef ScPairedNeuron < ScNeuron
  
  properties
    p_protocol_signal_tag
  end
  
  properties (Dependent)
    protocol_signal_tag
  end
  
  methods
    
    function obj = ScPairedNeuron(varargin)
      obj@ScNeuron(varargin{:});
    end
    
    
    function set.protocol_signal_tag(obj, val)
      obj.p_protocol_signal_tag = val;
    end
    
    
    function val = get.protocol_signal_tag(obj)
      
      if isempty(obj.p_protocol_signal_tag)
        val = obj.signal_tag;
      else
        val = obj.p_protocol_signal_tag;
      end
      
    end
    
  end
end