classdef ScGuiComponent < handle
  
  properties
    ui_object
  end
  
  methods
    
    function obj = ScGuiComponent(ui_object)
      obj.ui_object = ui_object;
    end
    
    function set(obj, varargin)
      set(obj.ui_object, varargin{:});
    end
    
    function varargout = get(obj, varargin)
      varargout = get(obj.ui_object, varargin{:});
    end
    
  end
  
end