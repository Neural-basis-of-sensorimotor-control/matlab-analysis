classdef ScBaseList < handle
  
  properties (Abstract)
    n
  end
  
  methods
    
    function n = length(obj)
      n = obj.n;
    end
    
    
    function val = get_item(obj, varargin)
      val = obj.get(varargin{:});
    end
    
    
    function val = get_items(obj, varargin)
      val = obj.get(varargin{:});
    end
    
    
    function val = get_values(obj, varargin)
      val = obj.values(varargin{:});
    end
    
    
    function obj = add_to_list(obj, varargin)
      obj.add(varargin{:});
    end
    
    
    function val = isempty(obj)
      val = obj.n == 0;
    end
    
  end
  
end