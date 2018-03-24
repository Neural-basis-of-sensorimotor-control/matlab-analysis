classdef SignalManager < handle
  
  properties
    v1
    v2
  end
  
  properties (Dependent)
    signal1
    signal2
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_signal1
    m_signal2
  end
  
  properties (Abstract)
    amplitude
    waveform
  end
  
  methods (Abstract)
    varargout = clear_unused_axes(varargin)
  end
  
  methods

    function obj = SignalManager()
      obj.m_signal2 = sc_tool.EmptyClass();
    end
    
    
    function val = get.signal1(obj)
      val = obj.m_signal1;
    end
    
    function set.signal1(obj, val)
      
      obj.m_signal1 = val;
      
      if isempty(obj.m_signal1)
        
        obj.v1        = [];
        obj.amplitude = [];
        obj.waveform  = [];
      
      else
        
        obj.v1        = obj.m_signal1.get_v(true, true, true, true);
        obj.amplitude = get_set_val(obj.m_signal1.amplitudes.list, obj.amplitude, 1);
        obj.waveform  = get_set_val(obj.m_signal1.waveforms.list, obj.waveform, 1);
      
      end
      
    end
    
    function val = get.signal2(obj)
      val = obj.m_signal2;
    end
    
    function set.signal2(obj, val)
      
      obj.m_signal2 = val;
      
      if isempty(obj.m_signal2) || isa(obj.m_signal2, 'sc_tool.EmptyClass')
        
        obj.v2 = [];
        obj.clear_unused_axes();
        
      else
        
        obj.v2 = obj.m_signal1.get_v(true, true, true, true);
      
      end
      
    end
    
  end
end