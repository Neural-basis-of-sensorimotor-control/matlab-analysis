classdef ScBaseList < handle
  
  properties (Abstract)
    n
  end
  
  methods (Abstract)
    
    get(obj, varargin);
    add(obj, varargin);
    values(obj, varargin);
    add_to_list(obj, varargin);
  
  end
  
  methods
    
    function n = list_length(obj)
      
      if numel(obj) == 0
        n = 0;
      else
        n = obj.n;
      end
      
    end
    
    
    function val = get_item(obj, varargin)
      
      if numel(obj) == 0
        val = {};
      else
        val = obj.get(varargin{:});
      end
      
    end
    
    
    function val = get_items(obj, varargin)
      
      if numel(obj) == 0
        val = {};
      else
        val = obj.get(varargin{:});
      end
      
    end
    
    
    function val = get_values(obj, varargin)
      
      if numel(obj) == 0
        val = {};
      else
        val = obj.values(varargin{:});
      end
      
    end
    
    
    function val = isempty(obj)
      
      if numel(obj) == 0
        val = 0;
      else
        val = obj.n == 0;
      end
      
    end

  end
  
end