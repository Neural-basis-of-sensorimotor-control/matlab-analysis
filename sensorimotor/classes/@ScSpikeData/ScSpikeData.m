classdef ScSpikeData < ScNeuron
  
  % For storing meta data to enable repeatable automated analysis.
  % Must only contain primitive data types.
  
  properties
    folder_path
    file_name
    file_ext
    read_column
  end
  
  methods
    
    function obj = ScSpikeData(varargin)
            
      obj.read_column = 1;
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end  
      
    end
    
    function val = get_file_path(obj)
      val = [obj.folder_path filesep obj.file_name '.' obj.file_ext];
    end
    
  end
  
end