function setfigs(figs, varargin)

for i=1:length(figs)
  
  j = 1;
  
  while j<=length(varargin)
    
    if isfunction(varargin{j})
      
      fcn = varargin{j};
      fcn(figs(i));
      
      j = j+1;
      
    end
    
  end
  
end