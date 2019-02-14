classdef Saveable < handle
  
  properties (Dependent)
    isSaved
  end
  
  properties (SetAccess = 'private')
    m_isSaved   = true
  end
  
  methods
    
    function val = get.isSaved(obj)
      val = obj.m_isSaved;
    end
    
    function set.isSaved(obj, val)
      obj.m_isSaved = val;
    end
    
    function saveobj(obj)
      obj.isSaved = true;
    end
    
    function loadObj(obj)
      obj.m_isSaved = true;
    end
  end
end