classdef List < handle
  
  properties
    values
    counter
    max_nbr_of_elements
  end
  
  methods
    function obj = List(argin)
      
      if length(argin)>1 || ~isnumeric(argin)
        obj.values = argin;
        obj.counter = length(argin);
        obj.max_nbr_of_elements = length(argin);
      else
        obj.max_nbr_of_elements = argin;
        obj.counter = 0;
      end
      
    end
    
    function element = subsref(obj, s)
      type = s.type;
      subs = s.subs{:};
      
      if any(subs) > obj.counter
        error('Index values exceedes size of list');
      end
      
      
      switch type
        
        case '()'
          element = obj.values(subs);
          
        case '{}'
          element = obj.values{subs};
          
        otherwise
          error('Illegal indexing method: %s', type);
      end
      
    end
    
    
    function val = len(obj)
      val = obj.counter;
    end
    
    
    function subset(obj, varargin)
      obj.values = get_items(obj.values, varargin{:});
      obj.counter = length(obj.values);
    end

    function rm(obj, rm_indx)

      if any(rm_indx > obj.counter)
        error('indx > number of elements');
      end

      keep_indx = 1:obj.counter;
      keep_indx(rm_indx) = [];
      obj.counter = obj.counter - length(rm_indx);
      obj.values(1:obj.counter) = obj.values(keep_indx);
      
    end
    
    
    function val = list(obj)
      val = obj.values(1:obj.counter);
    end
    
  end
end