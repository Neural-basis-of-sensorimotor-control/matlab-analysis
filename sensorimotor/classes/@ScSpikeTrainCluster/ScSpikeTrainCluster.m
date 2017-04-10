classdef ScSpikeTrainCluster < handle
  
  properties
    neurons
    tag
    raw_data_file
    time_sequences
  end
  
  
  properties (SetAccess = 'private')
    stimtimes_is_updated
    touch_pattern_times_is_updated
    spont_activity_time_sequences_is_updated
    touch_pattern_time_sequences_is_updated
  end
  
  properties (SetAccess = 'private', GetAccess = 'private')
    stimtimes
    touch_pattern_times
    spont_activity_time_sequences
    touch_pattern_time_sequences
  end
  
  properties (Constant)
    time_since_last_stim = .1
    touch_pattern_delay = .1
    time_since_last_touch_pattern = .5
  end
  
  
  methods
    
    function obj = ScSpikeTrainCluster(varargin)
      
      obj.stimtimes_is_updated = false;
      obj.touch_pattern_times_is_updated = false;
      obj.spont_activity_time_sequences_is_updated = false;
      obj.touch_pattern_time_sequences_is_updated = false;
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
    end
    
    
    function times = get_stimtimes(obj)
      if isempty(obj.stimtimes_is_updated) || ~obj.stimtimes_is_updated
        obj.load_stimtimes();
      end
      
      times = obj.stimtimes;
    end
    
    function times = get_touch_pattern_times(obj)
      if isempty(obj.touch_pattern_times_is_updated) || ~obj.touch_pattern_times_is_updated
        obj.load_touch_pattern_times();
      end
      
      times = obj.touch_pattern_times;
    end
    
    
    function times = get_spont_activity_time_sequences(obj)
      
      if ~obj.spont_activity_time_sequences_is_updated
        obj.update_spont_activity_time_sequences();
      end
      
      times = obj.spont_activity_time_sequences;
    end
    
    
    function times = get_touch_pattern_time_sequences(obj)
      
      if ~obj.touch_pattern_time_sequences_is_updated
        obj.update_touch_pattern_time_sequences();
      end
      
      times = obj.touch_pattern_time_sequences;
    end
    
    
    function load_stimtimes(obj)
      
      obj.stimtimes = ScSpikeTrainCluster.load_times(obj.raw_data_file, ...
        ScSpikeTrainCluster.get_stim_headers());
      obj.stimtimes_is_updated = true;
      
    end
    
    
    function load_touch_pattern_times(obj)
      
      obj.touch_pattern_times = ScSpikeTrainCluster.load_times(obj.raw_data_file, ...
        ScSpikeTrainCluster.get_touch_pattern_headers());
      obj.touch_pattern_times_is_updated = true;
      
    end
    
    
    function update_spont_activity_time_sequences(obj)
      
      dim = size(obj.get_stimtimes());
      
      obj.spont_activity_time_sequences = ...
        extract_time_sequence_disjunction(obj.time_sequences, ...
        obj.get_stimtimes()*[1 1] + ...
        ScSpikeTrainCluster.time_since_last_stim*[zeros(dim) ones(dim)]);
      
      obj.spont_activity_time_sequences_is_updated = true;
      
    end
    
    
    function update_touch_pattern_time_sequences(obj)
      
      n = size(obj.get_touch_pattern_times());
      
      obj.touch_pattern_time_sequences = ...
        extract_time_sequence_conjunction(obj.time_sequences, ...
        obj.get_touch_pattern_times()*[1 1] + ...
        repmat([ScSpikeTrainCluster.touch_pattern_delay ScSpikeTrainCluster.time_since_last_touch_pattern], [n 1]));
      
      obj.touch_pattern_time_sequences_is_updated = true;
      
    end
    
  end
  
  
  methods (Static)
    
    function val = get_stim_headers()
      val = {'V1', 'V2', 'V3','V4', 'V5', 'V6', 'V7', 'V8', '1000'};
    end
    
    
    function val = get_touch_pattern_headers()
      val = get_intra_patterns();
    end
    
    
    function times = load_times(raw_data_file, selected_headers)
      
      fid = fopen(raw_data_file);
      header = fgetl(fid);
      fclose(fid);
      
      header = strrep(header, '0.5,"fa"', '0.5 fa');
      header = strrep(header, '0.5,"sa"', '0.5 sa');
      header = strrep(header, '1,"fa"', '1.0 fa');
      header = strrep(header, '1,"sa"', '1.0 sa');
      header = strrep(header, '2,"fa"', '2.0 fa');
      header = strrep(header, '2,"sa"', '2.0 sa');
      header = strrep(header, '"flat","fa"', 'flat fa');
      header = strrep(header, '"flat","sa"', 'flat sa');
      header = strrep(header, '"1p","electrode",1', '1p electrode 1');
      header = strrep(header, '"1p","electrode",2', '1p electrode 2');
      header = strrep(header, '"1p","electrode",3', '1p electrode 3');
      header = strrep(header, '"1p","electrode",4', '1p electrode 4');
      
      headers = strsplit(header, ',');
      headers = strrep(headers, '"', '');
      headers = strrep(headers, '''', '');
      
      is_selected = false(size(headers));
      
      for i=1:length(selected_headers)
        is_selected = is_selected | strcmp(headers, selected_headers{i});
      end
      
      times = dlmread(raw_data_file, ',', 1, 0);
      times = times(:, is_selected);
      times = times(:);
      times = times(isfinite(times) & times ~= 0);
      
      times = sort(times);
    end
    
  end
end