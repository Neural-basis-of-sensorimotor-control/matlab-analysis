classdef EnableManager < handle
  
  properties (Dependent)
    enabled
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_enabled
  end
  
  methods
    
    function enable_buttons(obj, val)
      
      if isempty(obj.button_window)
        return
      end
      
      if islogical(val)
        
        if val
          val = 'on';
        else
          val = 'off';
        end
        
      elseif isempty(val)
        
        val = 'off';
        
      end
            
      panels = obj.button_window.Children;
      
      for i=1:length(panels)
        
        controls = panels(i).Children;
        
        for j=1:length(controls)
          set(controls(j), 'Enable', val);
        end
        
      end
      
      obj.m_enabled = val;
      
    end
  end
  
  methods
    
    function val = get.enabled(obj)
      val = obj.m_enabled;
    end
    
    function set.enabled(obj, val)
      obj.enable_buttons(val);
    end
    
  end
  
end