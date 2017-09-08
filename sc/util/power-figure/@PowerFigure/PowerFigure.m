classdef PowerFigure < handle
  
  properties
    h_figure
  end
  
  methods
    
    function obj = PowerFigure()
      
    end
    
    
    function val = get(obj, varargin)
      
      val = get(obj.h_figure, varargin{:});
      
    end
    
    
    function set(obj, varargin)
      
      set(obj.h_figure, obj.varargin{:});
    
    end
    
    
    function val = subsref(obj, s)
      
      switch s.type
        
        case '.'
          
          if iscell(s.subs)
            error('subsref not implemented for cell input');
          end
          
          val = get(obj.h_figure, s.subs); 
        
        case '()'
          
          error('subsref not implemented for brackets');
        
        case '{}'
          
          error('subsref not implemented for curly brackets');
      
      end
      
    end
    
    
    function obj = subsasgn(obj, s, val)
      
      switch s.type
        
        case '.'
          
          if iscell(s.subs)
            error('subsref not implemented for cell input');
          end
          
          set(obj.h_figure, s.subs, val);
          
        case '()'
          
          error('subsref not implemented for brackets');
        
        case '{}'
          
          error('subsref not implemented for curly brackets');
      
      end
      
      
    end
    
  end
  
end