classdef TriggerParent < handle
  %Triggerparent = a channel with child object that can be triggered
  %on
  %implements istrigger (return false), and triggers (return all
  %children that are triggers)
  
  properties
    tag
    m_triggers
  end
  
  properties (Dependent)
    istrigger
  end
  
  
  methods
    
    function obj = TriggerParent(tag, triggers)
      obj.tag = tag;
      if nargin < 2
        triggers = ScCellList();
      end
      obj.m_triggers = triggers;
    end
    
    function retval = get.istrigger(~)
      retval = false;
    end
    
    function retval = triggers(obj)
      retval = obj.m_triggers;
    end
    
    
    
    
  end
  
end