function print(varargin)

if sc_debug.get_mode()
  
  fprintf('DEBUG: ');
  
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
  
  i  = 2;
  st = dbstack;
  
  while i <= sc_debug.get_recursive_depth()+1 && i < length(st)
    
    fprintf('\tline %d in %s (%s)\n', st(i).line, st(i).name, st(i).file);
    i = i + 1;
    
  end
  
end

end
