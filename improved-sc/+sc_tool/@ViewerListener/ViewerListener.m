classdef ViewerListener < handle
  
  properties
    viewer
    ui_object
    property
    fcn_get_string
    fcn_get_value
    fcn_callback
  end
  
  methods
    
    function obj = ViewerListener(viewer, ui_object, property, fcn_get_string, ...
        fcn_get_value, fcn_callback)
      
      if nargin < 3, property       = []; end
      if nargin < 4, fcn_get_string = []; end
      if nargin < 5, fcn_get_value  = []; end
      if nargin < 6, fcn_callback   = []; end
      
      obj.viewer         = viewer;
      obj.ui_object      = ui_object;
      obj.property       = property;
      obj.fcn_get_string = fcn_get_string;
      obj.fcn_get_value  = fcn_get_value;
      obj.fcn_callback   = fcn_callback;
      
      obj.listener_callback();
      
      if ~isempty(obj.property)
        
        sc_addlistener(viewer, obj.property, @(~,~) obj.listener_callback(), ...
          obj.ui_object);
        
      end
      
      set(obj.ui_object, 'Callback', @(~, ~) obj.callback());
      
    end
    
    
    function listener_callback(obj)
      
      if ~isempty(obj.property) && isempty(obj.viewer.(obj.property))
        
        set(obj.ui_object, 'Visible', 'off')
        
      else
        
        [str, val] = obj.get_str_val();
        set(obj.ui_object, 'String', str, 'Value', val, 'Visible', 'on');
        
      end
    end
    
    function callback(obj)
      
      if ~isempty(obj.fcn_callback)
        
        obj.fcn_callback(obj.viewer, get(obj.ui_object, 'String'), ...
          get(obj.ui_object, 'Value'));
        
      end
      
    end
    
    
    function [str, val] = get_str_val(obj)
      
      if isempty(obj.fcn_get_string)
        str = '';
      elseif ischar(obj.fcn_get_string)
        str = obj.fcn_get_string;
      elseif isfunction(obj.fcn_get_string)
        str = obj.fcn_get_string(obj.viewer);
      end
      
      if isempty(obj.fcn_get_value)
        val = [];
      elseif isnumeric(obj.fcn_get_value)
        val = obj.fcn_get_value;
      elseif isfunction(obj.fcn_get_value)
        val = obj.fcn_get_value(obj.viewer);
      end
      
      if ~isnumeric(val) && ~isempty(val)
        
        if isa(val, 'sc_tool.EmptyClass')
          val = find(equals(get_values(str, 'tag'), val.tag));
        else
          val = find(equals(str, val));
        end
        
      end
      
      if ~isempty(str) && ~ischar(str) && ~isnumeric(str) && ...
           ~(iscell(str) && ischar(str{1}))
         
        str = get_values(str, 'tag');
      
      end
      
    end
  end
  
end