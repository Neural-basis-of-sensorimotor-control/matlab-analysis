classdef ScSpikeData < ScNeuron & ScTrigger
  
  properties
    
    raw_data_file
    column_indx
    
  end
  
  properties (Transient)
    
    spiketimes_is_updated
    spiketimes
    
  end
  
  methods
    
    function obj = ScSpikeData(varargin)
      obj@ScNeuron();
      
      obj.spiketimes_is_updated = false;
      obj.update_properties(varargin{:});
    end
    
    
    function load_spiketimes(obj, base_dir)
      
      if nargin<2
        
        filepath = obj.raw_data_file;
        
      else
        
        if isfile(obj.raw_data_file) && ...
            length(obj.raw_data_file) > length(base_dir) && ...
            startsWith(obj.raw_data_file, base_dir) && ...
            ~isfile([base_dir obj.raw_data_file])
          
          warning('Warning: Appears to be absolute path to raw data file');
          obj.raw_data_file = obj.raw_data_file(length(base_dir)+1:end);
          
        end
        
        filepath = [base_dir obj.raw_data_file];
        
      end
      
      if ~isfile(filepath)
        
        tmp_filepath = [sc_settings.get_default_experiment_dir() filepath];
        
        if isfile(tmp_filepath)
          
          filepath = tmp_filepath;
          
        else
          
          error('Could not find file %s.\n', filepath);
          
        end
        
      end
      
      if ischar(obj.column_indx)
        
        times = ScSpikeTrainCluster.load_times(filepath, obj.column_indx);
        
      else
        
        data = dlmread(filepath, ',', 1, 0);
        times = data(:, obj.column_indx);
        times = times(isfinite(times) & times ~= 0);
        
      end
      
      obj.spiketimes = times;
      obj.spiketimes_is_updated = true;
      
    end
    
    
    function times = get_spiketimes(obj, varargin)
      
      if isempty(obj.spiketimes_is_updated) || ~obj.spiketimes_is_updated
        obj.load_spiketimes(varargin{:});
      end
      
      times = obj.spiketimes;
      
    end
    
    
    function times = gettimes(obj, tmin, tmax, varargin)
      
      times = obj.get_spiketimes(varargin{:});
      times = times(times > tmin & times <= tmax);
      
    end
    
  end
  
  
  methods (Static)
    
    function s = loadobj(s)
      s.spiketimes_is_updated = false;
    end
    
  end
end