classdef DefineThreshold < handle
  
  methods (Access = 'public')
    
    varargout = init_plot(varargin)
    varargout = import_threshold(varargin)
    varargout = remove_limit(varargin)
    varargout = plot_starting_point(varargin)
    
  end
  
  methods (Access = 'protected')
    
    varargout = btn_dwn_define_starting_point(varargin)
    varargout = clear_objects(varargin)
    varargout = create_ui_context_menu(varargin)
    varargout = plot_limits(varargin)
    varargout = plot_single_limit(varargin)
    varargout = window_btn_motion_fcn(varargin)
    varargout = window_btn_up_fcn(varargin)
    varargout = update_background_callbacks(varargin)
    
  end
  
  methods (Access = 'private')
    
    varargout = drag_object(varargin)
    
  end
  
  methods (Static, Access = 'private')
    
    varargout = update_starting_point(varargin)
    varargout = update_lower_bound(varargin)
    varargout = update_upper_bound(varargin)
    
  end
  
  properties (SetAccess = 'public')
    
    color
    x0
    y0
    
  end
  
  properties (SetAccess = 'private')
    
    h_axes
    has_unsaved_changes
    
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
    
    function obj = DefineThreshold(h_axes)
      
      obj.has_unsaved_changes = false;
      obj.color               = 'b';
      obj.h_axes              = h_axes;
      
      hold(obj.h_axes, 'on');
      
    end
    
  end
  
end