classdef TriggerParent < sc_experiment.EmptyClassPlaceholder
  
  properties
    tag
  end
  
  methods (Static)
    varargout = make_empty_class(varargin)
  end
  
  methods 
    
    function  trigger_tags = get_trigger_tags(~)
      trigger_tags = {};
    end
    
  end
  
end