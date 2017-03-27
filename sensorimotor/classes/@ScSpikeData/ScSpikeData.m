classdef ScSpikeData < ScNeuron
  
  % For storing meta data to enable repeatable automated analysis.
  % Must only contain primitive data types.
  
  properties
    top_directory
    folder_name
    file_name
    read_column
  end
  
  properties (Dependent)
    file_path
  end
  
  methods
    
    function obj = ScSpikeData(varargin)
            
      obj.read_column = 1;
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end  
      
    end
    
    function val = get.file_path(obj)
      val = [obj.top_directory filesep obj.folder_name filesep obj.file_name];
    end
    
  end
  
end