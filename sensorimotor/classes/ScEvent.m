classdef ScEvent < handle

  properties (GetAccess = 'private', SetAccess = 'protected')  
    times
  end
  
  methods
  
    function t = gettimes(obj,tmin,tmax)
      t = obj.times(obj.times >= tmin & obj.times < tmax);
    end
    
    function sc_clear(obj)
      obj.times = [];
    end
  end
end
