classdef ScFilter < handle
  
  methods (Abstract)
    update(obj, v)
    v = apply(obj, v)
  end
  
  properties
    process_order = 0
  end
  
  methods (Static)
    function obj = loadobj(a)
      if isempty(a.process_order)
        a.process_order = 0;
      end
      obj = a;
    end
  end
end