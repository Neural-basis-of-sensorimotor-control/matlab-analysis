classdef Counter < handle
  
  properties
    tags            = {}
    counters        = []
    default_counter = 0
  end
  
  methods
    
    function val = get_count(obj, tag)
      
      if isempty(tag)
        
        val = obj.default_counter;
        
      else
        
        indx = find(cellfun(@(x) strcmp(x, tag), obj.tags));
        
        if length(indx) == 1
          val = obj.counters(indx);
        elseif isempty(indx)
          error('Could not find tag: %s', tag);
        else
          error('Multiple counters with identical tag: %s', tag);
        end
        
      end
      
    end
    
    
    function increment(obj, tag, incr)
      
      if isempty(tag)
        
        obj.default_counter = obj.default_counter + incr;
        
      else
        
        indx = find(cellfun(@(x) strcmp(x, tag), obj.tags));
        
        if length(indx) == 1
          obj.counters(indx) = obj.counters(indx) + incr;
        elseif isempty(indx)
          error('Could not find tag: %s', tag);
        else
          error('Multiple counters with identical tag: %s', tag);
        end
        
      end
    end
    
    
    function rm_tag(obj, tag)
      
      indx = find(cellfun(@(x) strcmp(x, tag), obj.tags));
      
      if length(indx) == 1
        
        obj.counters(indx) = [];
        obj.tags(indx)     = [];
        
      elseif isempty(indx)
        
        error('Could not remove tag: %s', tag);
        
      else
        
        error('Multiple counters with identical tag: %s', tag);
        
      end
    end
    
    
    function reset_counter(obj, tag, val)
      
      if isempty(tag)
        
        obj.default_counter = val;
        
      else
        
        indx = find(cellfun(@(x) strcmp(x, tag), obj.tags));
        
        if length(indx) == 1
          
          obj.counters(indx) = val;
        
        elseif isempty(indx)
        
          obj.tags     = add_to_list(obj.tags,     tag);  
          obj.counters = add_to_list(obj.counters, val);
        
        else
          
          error('Multiple counters with identical tag: %s', tag);
        
        end
        
      end
    end
    
  end
  
end