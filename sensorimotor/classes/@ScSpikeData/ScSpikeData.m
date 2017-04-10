classdef ScSpikeData < ScNeuron
  
  properties
    raw_data_file
    column_indx
    spiketimes
    spiketimes_is_updated
  end
  
  methods
    function obj = ScSpikeData(varargin)
      obj@ScNeuron();
      
      obj.spiketimes_is_updated = false;
      obj.update_properties(varargin{:});
    end
    
    function load_spiketimes(obj)
      data = dlmread(obj.raw_data_file, ',', 1, 0);
      times = data(:, obj.column_indx);
      obj.spiketimes = times(isfinite(times) & times ~= 0);
      obj.spiketimes_is_updated = true;
    end
    
    function times = get_spiketimes(obj)
      if ~obj.spiketimes_is_updated
        obj.load_spiketimes;
      end
      
      times = obj.spiketimes; 
    end
    
  end
  
end