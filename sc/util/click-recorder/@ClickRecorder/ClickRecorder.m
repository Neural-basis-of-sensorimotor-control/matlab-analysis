classdef ClickRecorder < handle
  
  properties (Dependent)
    h_axes
  end
  
  properties
    
    clicked_points
    all_objects
    active_object
    active_label
    active_index
    n
    
  end
  
  properties (SetAccess = 'private')
    m_axes
  end
  
  
  methods
    
    function obj = ClickRecorder(h_axes, n)
      
      obj.h_axes                = h_axes;
      obj.n                     = n;
      obj.clicked_points        = struct('x', [], 'y', []);
      obj.clicked_points(obj.n) = struct('x', [], 'y', []);
      
    end
    
    
    function set.h_axes(obj, val)
      obj.m_axes = val;
    end
    
    
    function val = get.h_axes(obj)
      
      if ~ishandle(obj.m_axes)
        
        figure;
        obj.m_axes = axes;
        
      end
      
      val = obj.m_axes;
      
    end
    
  end
  
end