classdef EditPlotHandle < handle
  
  properties
  
    h_axes
    dt
    h_has_unsaved_changes
    threshold
    indx
    type
    src
    x0
    y0
  
  end
  
  
  methods
    
    function obj = EditPlotHandle(h_axes, dt, h_has_unsaved_changes)
      
      obj.h_axes                = h_axes;
      obj.dt                    = dt;
      obj.h_has_unsaved_changes = h_has_unsaved_changes;
    
    end
    
  end
  
end