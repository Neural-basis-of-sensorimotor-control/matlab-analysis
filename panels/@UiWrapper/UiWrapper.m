classdef UiWrapper < handle
  %Object that references a uicontrol, uipanel, etc
  properties
    uihandle
  end 

  methods 
    function obj = UiWrapper(uihandle)
      obj.uihandle = uihandle;
    end

    function argout = get(obj,varargin)
      if nargout
        argout = get(obj.uihandle,varargin{:});
      else
        get(obj.uihandle,varargin{:});
      end
    end

    function argout = set(obj,varargin)
      if nargout
        argout = set(obj.uihandle,varargin{:});
      else
        set(obj.uihandle,varargin{:});
      end
    end

    function delete(obj)
      if ~isempty(obj.uihandle) && (ishandle(obj.uihandle) || isobject(obj.uihandle))
        delete(obj.uihandle)
      end
    end
  end
end
