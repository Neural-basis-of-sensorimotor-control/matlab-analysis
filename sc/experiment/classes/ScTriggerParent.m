classdef ScTriggerParent < handle
  
  methods (Abstract)
    %Populate triggers with e.g ScSpikeTrain objects
    sc_loadtimes(obj);
  end
  
  properties
    triggers
  end
  
  properties (Dependent)
    istrigger
  end
  
  methods
    
    function sc_clear(obj)
      obj.triggers = ScList;
    end
    
    
    function istrigger = get.istrigger(~)
      istrigger = false;
    end
    
    function get_trigger_tags(obj)
      error('Function %s not implemented', mfilename);
    end
    
  end
end
