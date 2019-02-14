classdef GenericTemplate < hamo.templates.Template
  
  properties
    triggerIndx
   end
  
  properties (Dependent)
    matchingFcn
    updateTemplateFcn
  end
  
  properties (SetAccess = 'protected')
    m_matchingFcn
    m_updateTemplateFcn
  end
  
  methods
    
    function obj = GenericTemplate(shape, tag) 
      obj.shape = shape;
      obj.tag   = tag;
    end
    
    function val = get.matchingFcn(obj)
      if isempty(obj.m_matchingFcn)
        val = @(varargin) [];
      else
        val = obj.m_matchingFcn;
      end
    end
    
    function set.matchingFcn(obj, val)
      obj.m_matchingFcn = val;
      obj.isUpdated = false;
    end
    
    function val = get.updateTemplateFcn(obj)
      if isempty(obj.m_updateTemplateFcn)
        val = @(varargin) [];
      else
        val = obj.m_updateTemplateFcn;
      end
    end
    
    function set.updateTemplateFcn(obj, val)
      obj.m_updateTemplateFcn = val;
      obj.updateTemplate();
      obj.isUpdated = false;
    end
    
    function updateTemplate(obj)
      obj.updateTemplateFcn(obj);
    end
      
    function indx = match_v(obj, vInput, varargin)
      indx = obj.matchingFcn(obj, vInput, varargin{:});
      obj.triggerIndx = indx;
    end
    
    function val = getTriggerTimes(obj)
      val = obj.triggerIndx*obj.dt;
    end

  end
  
end