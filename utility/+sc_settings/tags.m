classdef tags
  
  properties (Constant)
    
    DEFAULT           = 'sc_default'
    INTRA             = 'sc_intra'
    TEST              = 'sc_test'
    HANNES            = 'sc_hmogensen'
    
    LAST_EXPERIMENT   = 'last_experiment'
    EXPERIMENT_DIR    = 'intra_experiment_dir'
    RAW_DATA_DIR      = 'raw_data_dir'
    PRETRIGGER        = 'pretrigger'
    POSTTRIGGER       = 'posttrigger'
    AXES_HEIGHT       = 'axes_height'
    
    SETTINGS_FILENAME = 'sc.xml';
    
  end
  
  methods (Access = 'private')
    
    function obj = tags()
    end
    
  end
  
end