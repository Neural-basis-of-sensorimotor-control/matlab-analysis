classdef DummyHandle < handle
  
  properties (SetObservable)
    x
  end
  
  methods
    
    function st_x(obj, ~, val)
      obj.x = val + 1;
    end
    
  end
  
end