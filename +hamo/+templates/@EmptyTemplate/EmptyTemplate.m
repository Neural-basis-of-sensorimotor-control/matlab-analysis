classdef EmptyTemplate < hamo.templates.Template
  
  properties (Dependent)
    tMin
    tMax
  end
  
  properties (SetAccess = 'private')
    m_tMin
    m_tMax
  end
  
  methods
    
    function obj = EmptyTemplate(shape, tag, tMin, tMax)
      obj.shape = shape;
      obj.tag   = tag;
      obj.tMin  = tMin;
      obj.tMax  = tMax;
    end
    
    function indx = match_v(varargin)
      indx = [];
    end
    
    function val = getTriggerTimes(~)
      val = [];
    end
    
    function val = get.tMin(obj)
      val = obj.m_tMin;
    end
    
    function set.tMin(obj, val)
      obj.m_tMin = val;
    end
    
    function val = get.tMax(obj)
      val = obj.m_tMax;
    end
    
    function set.tMax(obj, val)
      obj.m_tMax = val;
    end
    
  end
  
end
