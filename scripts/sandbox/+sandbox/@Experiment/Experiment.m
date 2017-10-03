classdef Experiment < handle
  
  properties
    tag
    raw_data_dir_base
    raw_data_dir_folder
    files
  end
  
  methods
    
    function val = sc_settings.get_raw_data_dir(obj)
      
      val = [obj.raw_data_dir_base filesep obj.raw_data_dir_folder];
      val = strrep(val, '/', filesep);
      val = strrep(val, '\', filesep);
      
    end
    
  end
end