classdef ScFilter < ScDynamicClass
  
  methods (Abstract)
    update(obj, v)
    v = apply(obj, v)
  end
  
  properties
    process_order = 0
  end
  
end