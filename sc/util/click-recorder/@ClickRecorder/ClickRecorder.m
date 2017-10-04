classdef ClickRecorder < handle
  
  properties
  
    h_axes
    clicked_points
    all_objects
    active_object
    active_label
    active_index
    n
  
  end
  
  methods
    
    function obj = ClickRecorder(h_axes, n)
      
      obj.h_axes                = h_axes;
      obj.n                     = n;
      obj.clicked_points        = struct('x', [], 'y', []);
      obj.clicked_points(obj.n) = struct('x', [], 'y', []);
      
    end
    
  end
end