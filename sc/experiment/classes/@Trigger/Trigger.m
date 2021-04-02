classdef Trigger < ScTrigger
  %Triggers = objects containing a tag and timestamps
  %Implement function gettimes, and property istrigger returns true
  properties
    tag
    times
  end
  
  properties (Dependent)
    istrigger
  end
  
  methods
    function obj = Trigger(tag, times)
      obj.tag = tag;
      if nargin>1
        obj.times = times;
      end
    end
    
    function retval = gettimes(obj, tmin, tmax)
      retval = obj.times(obj.times >= tmin & obj.times < tmax);
    end
    
    function retval = get.istrigger(~)
      retval = true;
    end
    
  end
  
  
end