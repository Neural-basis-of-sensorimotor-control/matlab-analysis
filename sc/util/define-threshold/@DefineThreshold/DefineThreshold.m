classdef DefineThreshold < handle
  
  methods
    
    varargout = init_plot(varargin)
    varargout = import_threshold(varargin)
    varargout = remove_limit(varargin)
    varargout = plot_starting_point(varargin)
    varargout = delete_all_objects(varargin)
    varargout = export_to_threshold(varargin)
    
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
    varargout = move_limits(varargin)
    
  end
  
  properties
    
    color
    has_unsaved_changes
    h_axes
    
    x0
    y0
    x
    y_lower
    y_upper
    
  end
  
  properties (SetAccess = 'private')
    
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