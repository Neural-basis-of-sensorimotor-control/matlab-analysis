classdef RawDataFile < handle
  
  properties
    tag
    parent
    filename
  end
  
  
  methods
    
    function val = get_abs_file_path(obj)
      
      val = [obj.parent.get_raw_data_dir() filesep obj.filename];
      
    end
    
  end
end