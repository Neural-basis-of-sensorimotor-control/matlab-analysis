classdef ScSimpleFilter < ScFilter
  
  methods (Abstract)
    val = get_filter_indx(obj)
  end
  
  properties
    parent
    indx_width = 100
    is_on = true
  end
  
  methods
    
    function obj = ScSimpleFilter(parent)
      obj.parent = parent;
    end
    
    
    function update(varargin)
    end
    
    
    function v = apply(obj, v)
      if ~obj.is_on
        return
      end
      
      filter_indx = obj.get_filter_indx();
      
      v = simple_artifact_filter(v, obj.indx_width, filter_indx);
    end
    
  end
  
  methods (Static)
    function obj = loadobj(a)
      obj = loadobj@ScFilter(a);
    end
  end
end