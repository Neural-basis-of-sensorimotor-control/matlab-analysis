function debug_printout(varargin)

if get_debug_mode()
  
  for i=1:length(varargin)
    
    arg = varargin{i};
    
    switch (class(arg))
      
      case 'double'
        
        fprintf('%d\t', arg)
        
      case 'char'
        
        fprintf('%s\t', arg);
        
      otherwise
        
        error('Unknown type: %s', class(arg));
        
    end
    
  end
  
  fprintf('\n');
  
end