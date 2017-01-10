classdef ScTemplate < handle

  methods (Abstract)
    update(obj, v)
    %indx = match(obj, v)
  end
  
  properties
    process_order
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
