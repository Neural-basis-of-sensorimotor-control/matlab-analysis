classdef TimeRangeManager < handle
  
  properties (Dependent)
    pretrigger
    posttrigger
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_pretrigger
    m_posttrigger
  end
  
  methods (Abstract)
    varargout = update_plots(varargin)
  end
  
  methods
    
    function val = get.pretrigger(~)
      val = sc_settings.get_pretrigger();
    end
    
    function set.pretrigger(obj, val)
      
      sc_settings.set_pretrigger(val);
      obj.m_pretrigger = val;
      
      if obj.m_pretrigger < obj.m_posttrigger
        obj.update_plots;
      end
      
    end
    
    function val = get.posttrigger(~)
      val = sc_settings.get_posttrigger();
    end
    
    function set.posttrigger(obj, val)
      
      sc_settings.set_posttrigger(val);
      obj.m_posttrigger = val;
      
      if obj.m_pretrigger < obj.m_posttrigger
        obj.update_plots;
      end
      
    end
    
  end
end