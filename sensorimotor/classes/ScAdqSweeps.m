classdef ScAdqSweeps < ScEvent & ScTrigger
  properties
    nbrofsweeps
    sweepwidth
    tag = 'Sweep #'
  end
  
  properties (Dependent)
    istrigger
  end
  
  methods
    function obj = ScAdqSweeps(nbrofsweeps, sweepwidth, tag)
      obj.nbrofsweeps = nbrofsweeps;
      obj.sweepwidth = sweepwidth;
      if nargin>2,    obj.tag = tag;  end
    end
    
    function sc_loadtimes(obj)
      obj.times = -obj.sweepwidth/2 + (1:obj.nbrofsweeps)'*obj.sweepwidth;
    end
    
    function istrigger = get.istrigger(~)
      istrigger = true;
    end
  end
end
