classdef DefineThreshold < handle
  
  methods (Static, Access = 'private')
    
    varargout = update_starting_point(varargin)
    varargout = update_lower_bound(varargin)
    varargout = update_upper_bound(varargin)
  
  end
  
  properties (SetAccess = 'private')
  
    h_axes
        
    x0
    y0
    x
    y_lower
    y_upper
    
    active_object_type
    active_object
    active_object_group
    active_index
    
    all_objects
    
  end
  
  methods
    
    function obj = DefineThreshold()
      
      obj.h_axes = gca;
      hold(obj.h_axes, 'on');
      
    end
    
  end
  
end