classdef NcChild < handle
  properties
    parent
  end
  properties (Dependent)
    time
  end
  methods
    function ret = get.time(obj)
      ret = obj.parent.time;
    end
    function ret = time_binned(obj)
      ret = obj.parent.time_binned;
    end
    function ret = binwidth(obj)
      ret = obj.parent.binwidth;
    end
    function ret = dt(obj)
      ret = obj.parent.dt;
    end
  end
end
