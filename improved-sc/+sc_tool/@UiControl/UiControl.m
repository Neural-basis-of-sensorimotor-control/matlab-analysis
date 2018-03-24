classdef UiControl < handle
  
  properties (Constant)
    default_width = 200
    default_height = 20
  end
  
  properties
    
    viewer
    ui_object
    
    style
    fcn_get_string
    fcn_get_value
    fcn_callback
    viewer_property
    width
    height

  end
  
  methods
    
    function obj = UiControl(viewer, style, fcn_get_string, fcn_get_value, ...
        fcn_callback, viewer_property, width, height)
      
      if nargin < 3,  fcn_get_string = [];          end
      if nargin < 4,  fcn_get_value  = [];          end
      if nargin < 5,  fcn_callback  = [];           end
      if nargin < 6,  viewer_property  = [];        end
      if nargin < 7,  width  = obj.default_width;   end
      if nargin < 8,  height = obj.default_height;  end
      
      obj.viewer          = viewer;
      obj.style           = style;
      obj.fcn_get_string  = fcn_get_string;
      obj.fcn_get_value   = fcn_get_value;
      obj.fcn_callback    = fcn_callback;
      obj.viewer_property = viewer_property;
      obj.width           = width;
      obj.height          = height;
      
      obj.ui_object = uicontrol('style', obj.style, ...
        'callback', @(~,~) control_callback(obj), ...
        'Visible', 'off');
      setheight(obj.ui_object, obj.height);
      
      if strcmpi(obj.style, 'text')
        set(obj.ui_object, 'HorizontalAlignment', 'left');
      end
      
      if ~isempty(obj.viewer_property)
        
        obj.listener_callback();
        sc_addlistener(obj.viewer, obj.viewer_property, ...
          obj.listener_callback, obj.ui_object);
        
      else
        
        if isempty(obj.fcn_get_string)
          str = '';
        elseif ischar(obj.fcn_get_string)
          str = obj.fcn_get_string;
        else
          str = obj.fcn_get_string(obj.viewer);
        end
        
        if isempty(str)
          set(obj.ui_object, 'Visible', 'off');
        else
          set(obj.ui_object, 'String', str, 'Visible', 'on');
        end
        
      end
      
    end
    
  end
  
  
  methods (Access = private)
    
    function control_callback(obj)
      
      indx = get(obj.ui_object, 'Value');
      str  = get(obj.ui_object, 'String');
      
      if ~isempty(obj.fcn_callback)
        obj.fcn_callback(obj.viewer, str, indx);
      end
      
    end
    
    
    function listener_callback(obj)
      
      if isempty(obj.fcn_get_string)
        str = [];
      elseif ischar(obj.fcn_get_string)
        str = obj.fcn_get_string;
      else
        str  = obj.fcn_get_string(obj.viewer);
      end
      
      if isempty(obj.fcn_get_value)
        indx = [];
      elseif isnumeric(obj.fcn_get_value)
        indx = obj.fcn_get_value;
      elseif ischar(obj.fcn_get_value)
        indx = obj.fcn_get_value;
      else
        indx  = obj.fcn_get_value(obj.viewer);
      end
      
      if ~isempty(str)
        
        if isnumeric(str)
          str = num2str(str);
        elseif iscell(str) && ~ischar(str{1})
          str = get_values(str, 'tag');
        elseif ~ischar(str(1))
          str = get_values(str, 'tag');
        end
        
      end
      
      if ~isempty(indx) && ~isnumeric(indx)
        
        if ischar(indx)
          indx = find(cellfun(@(x) strcmp(x, indx), str));
        else
          indx = find(cellfun(@(x) strcmp(x, indx.tag), str));
        end
        
      end
      
      if ~isempty(str) && isempty(indx)
        set(obj.ui_object, 'String', str, 'Value', 1, 'Visible', 'on');
      elseif isempty(str) && ~isempty(indx)
        set(obj.ui_object, 'String', '', 'Value', indx, 'Visible', 'on');
      elseif isempty(str) && isempty(indx)
        set(obj.ui_object, 'String', '', 'Value', 1, 'Visible', 'off');
      else
        set(obj.ui_object, 'String', str,  'Value', indx, 'Visible', 'on');
      end
      
    end
    
  end
  
end