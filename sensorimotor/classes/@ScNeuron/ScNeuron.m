classdef ScNeuron < handle
  
  % For storing meta data to enable repeatable automated analysis.
  % Must only contain primitive data types.
  
  properties
    experiment_filename
    file_tag
    signal_tag
    tmin
    tmax
    time_sequences
    template_tag
    tag
  end
  
  
  methods
    
    function obj = ScNeuron(varargin)
      
      obj.tmin = 0;
      obj.tmax = inf;
      
      obj.update_properties(varargin{:});
    end
    
    
    function update_properties(obj, varargin)
      
      i = 1;
      
      while i<=length(varargin)
        
        arg = varargin{i};
        
        if ischar(arg)
          i = i+1;
          obj.(arg) = varargin{i};
          
        elseif isa(arg, 'ScFile')
          obj.experiment_filename = arg.parent.save_name;
          obj.file_tag = arg.tag;
          
        else
          error('Input of type %s not valid', class(arg));
        end
        
        i = i+1;
      end
      
    end
  end
  
end