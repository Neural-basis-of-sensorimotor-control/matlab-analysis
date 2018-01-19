classdef EmptyClassPlaceholder < handle
  
  methods (Abstract, Static)
    empty_class = make_empty_class()
  end
  
  properties (Abstract)
    tag
  end
  
  properties (Constant)
    empty_signal_tag = '<empty>';
  end
  
  properties
    is_empty_class = false;
  end
  
  methods
    
    function populate_empty_class(obj)
      
      obj.tag            = sc_experiment.EmptyClassPlaceholder.empty_signal_tag;
      obj.is_empty_class = true;
      
    end
    
  end
  
end