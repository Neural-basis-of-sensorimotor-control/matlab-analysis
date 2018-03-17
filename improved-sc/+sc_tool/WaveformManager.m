classdef WaveformManager < handle
    
  properties (Dependent)
    waveform
  end
  
  properties (SetAccess = 'protected', SetObservable)
    m_waveform
  end
  
  properties
    modify_waveform
  end
  
  methods
    
    function val = get.waveform(obj)
      val = obj.m_waveform;
    end
    
    function set.waveform(obj, val)
      obj.m_waveform = val;
    end
    
  end
  
end