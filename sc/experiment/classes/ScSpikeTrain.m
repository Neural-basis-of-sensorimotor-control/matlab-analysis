classdef ScSpikeTrain < ScTrigger
  
  properties
    tag
  end

  properties (GetAccess = 'protected')
    times
  end

  methods
    
    function obj = ScSpikeTrain(tag, times)
      obj.tag = tag;
      obj.times = times;
    end

    
    function t = gettimes(obj, tmin, tmax)
      pos = obj.times > sc_ceil(tmin,1e-3) & obj.times < sc_floor(tmax,1e-3);
      t = obj.times(pos);
    end

    
    function sc_loadtimes(~)
    end
    
    
    function sc_clear(~)
    end
    
  end
end
