classdef HelpTextManager < handle
  
  properties (Dependent)
    help_text
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_help_text
  end
  
  methods
    
    function val = get.help_text(obj)
      val = obj.m_help_text;
    end
    
    function set.help_text(obj, val)
      
      obj.m_help_text = val;
      
      if ~isempty(val)
        disp(val);
      end
      
    end
    
  end
end