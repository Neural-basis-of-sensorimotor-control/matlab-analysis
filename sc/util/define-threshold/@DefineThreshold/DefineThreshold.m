classdef DefineThreshold < handle
  
  methods (Access = 'private')
    varargout = update_active_objects(varargin)
    varargout = reset_active_objects(varargin)
    varargout = clear_settings(varargin)
  end
  
  methods (Static)
    varargout = define(varargin)
  end
  
  properties
    
    waveform
    threshold
    v
    dt
    x0
    y0
    h_axes
    title_str
    
    active_object
    active_object_group
    active_object_type
    active_index
    
  end
  
  properties (SetAccess = 'private')
    btn_dwn_fcn_plots
    btn_dwn_fcn_axes
    add_threshold_automatically_btn_dwn
  end
  
  methods
    
    function obj = DefineThreshold()
      
    end
    
  end
  
end