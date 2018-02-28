classdef StimElectrode < handle
  
  properties (SetAccess = public)
    
    parent
    type
    index
    time
    tag
  
  end
  
  properties (Dependent)
  
    pattern_name
    total_index
    time_to_previous_stims
    time_to_last_identical_stim
    time_to_last_non_identical_stim
    time_to_next_stims
    time_to_subsequent_stim
    nbr_of_previous_stims
    tot_nbr_of_previous_stims
    time_to_last_stim
    type_of_last_stim
    name
    next_stim
    prev_stim
  
  end
  
  properties (Constant)
    types = {'V1', 'V2', 'V3', 'V4'};
  end
  
  methods
    
    function obj = StimElectrode(type, index, time)
      obj.type = type;
      obj.index = index;
      obj.time = time;
    end
    
    
    function val = get.total_index(obj)
      val = nnz(obj.parent.times <= obj.time);
    end
    
    function val = get.time_to_previous_stims(obj)
      tps = StimElectrode.types;
      val = ones(size(tps));
      for i=1:length(tps)
        str = {obj.parent.stim_electrodes.type};
        b_type = cellfun(@(x) strcmp(x, tps{i}), str);
        b_time = obj.time > obj.parent.times;
        times = obj.parent.times(b_type & b_time);
        max_time = obj.time - max(times);
        if ~isempty(max_time)
          val(i) = max_time;
        end
      end
    end
    
    function val = get.nbr_of_previous_stims(obj)
    
      tps = StimElectrode.types;
      val = nan(size(tps));
      
      for i=1:length(tps)
        str = {obj.parent.stim_electrodes.type};
        b_type = cellfun(@(x) strcmp(x, tps{i}), str);
        b_time = obj.time > obj.parent.times;
        val(i) = nnz(b_type & b_time);
      end
      
    end
    
    
    function val = get.time_to_next_stims(obj)
    
      tps = StimElectrode.types;
      val = ones(size(tps));
      
      for i=1:length(tps)
        str = {obj.parent.stim_electrodes.type};
        b_type = cellfun(@(x) strcmp(x, tps{i}), str);
        b_time = obj.time < obj.parent.times;
        min_time = min(obj.parent.times(b_type & b_time)) - obj.time;
      
        if ~isempty(min_time)
          val(i) = min_time;
        end
        
      end  
    end
    
    
    function val = get.time_to_last_stim(obj)
      val = min(obj.time_to_previous_stims);
    end
    
    function val = get.type_of_last_stim(obj)
      
      [~, ind] = min(obj.time_to_previous_stims);
      
      if obj.time_to_previous_stims(ind) < 1
        val = StimElectrode.types{ind};
      else
        val = 'None';
      end
      
    end
    
    
    function val = get.time_to_subsequent_stim(obj)
      val = min(obj.time_to_next_stims);
    end
    
    
    function val = get.tot_nbr_of_previous_stims(obj)
      val = sum(obj.nbr_of_previous_stims);
    end
    
    
    function val = get.name(obj)
      val = obj.parent.name;
    end
    
    
    function val = get.time_to_last_identical_stim(obj)
      
      ind = cellfun(@(x) strcmp(x, obj.type), StimElectrode.types);
      val = obj.time_to_previous_stims(ind);
    
    end
    
    
    function val = get.time_to_last_non_identical_stim(obj)
    
      ind = cellfun(@(x) strcmp(x, obj.type), StimElectrode.types);
      val = min(obj.time_to_previous_stims(~ind));
    
    end
    
    
    function val = get.tag(obj)
      val = sprintf('%s#%s#%d', obj.name, obj.type, obj.index);
    end
    
    
    function val = get.next_stim(obj)
    
      if obj.total_index == length(obj.parent.stim_electrodes)
        val = [];
      else
        val = obj.parent.stim_electrodes(obj.total_index + 1);
      end
      
    end
    
    
    function val = get.prev_stim(obj)
      
      if obj.total_index == 1
        val = [];
      else
        val = obj.parent.stim_electrodes(obj.total_index - 1);
      end
      
    end
    
    
    function val = get.pattern_name(obj)
      val = obj.parent.name;
    end
    
  end
end