classdef WaveformManager < handle
  
  properties (Dependent)
    waveform
    threshold
    threshold_indx
  end
  
  properties (SetAccess = 'protected', SetObservable)
    m_waveform
    m_threshold_indx
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
      
      if isempty(val)
        obj.threshold_indx = [];
      else
        obj.threshold_indx = max(1, obj.waveform.n);
      end
      
    end
    
    function val = get.threshold_indx(obj)
      val = obj.m_threshold_indx;
    end
    
    function set.threshold_indx(obj, val)
      obj.m_threshold_indx = val;
    end
    
    function val = get.threshold(obj)
      
      if ~isempty(obj.waveform) && obj.threshold_indx > obj.waveform.n
        val = obj.waveform.get(obj.m_threshold_indx);
      else
        val = [];
      end
      
    end
    
  end
  
end