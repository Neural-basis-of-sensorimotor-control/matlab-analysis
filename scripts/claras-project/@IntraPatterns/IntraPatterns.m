classdef IntraPatterns < handle
  
  properties
    patterns
  end
  
  properties (Dependent)
    electrodes
    stim_electrodes
    names
    types
    indexes
  end
  
  methods
    function obj = IntraPatterns()
    end
    
    function add_pattern(obj, pattern)
      if isempty(obj.patterns)
        obj.patterns = pattern;
      else
        obj.patterns(length(obj.patterns)+1) = pattern;
      end
    end
    
    %If length(varargin) == 0:
    % Return true if amplitude matches any stim in stim_electrodes
    %If length(varargin) > 0:
    % Return true if amplitude matches any of the stims in the argument
    % list
    function val = is_pattern(obj, amplitude, varargin)
      if length(amplitude) > 1
        val = false(size(amplitude));
        for i=1:length(val)
          val(i) = obj.is_pattern(amplitude(i), varargin{:});
        end
      else
        str = amplitude.tag;
        str = strsplit(str, '#');
        pattern_str = str{1};
        stim_str = str{2};
        index = str2double(str{3});
        pattern_ind = cellfun(@(x) strcmp(x, pattern_str), obj.names);
        stim_ind = cellfun(@(x) strcmp(x, stim_str), obj.types);
        index_ind = index == obj.indexes;
        val = any(pattern_ind & stim_ind & index_ind);
        if ~isempty(varargin)
          is_found = false;
          for i=1:length(varargin)
            if strcmp(amplitude.tag, varargin{i})
              is_found = true;
              break
            end
          end
          val = val && is_found;
        end
      end
    end
    
    function val = get_stim_electrode(obj, amplitude)
      if length(amplitude) > 1
        val = obj.get_stim_electrode(amplitude(1));
        for i=2:length(amplitude)
          val(length(val) + 1) = obj.get_stim_electrode(amplitude(i));
        end
      else
        str = amplitude.tag;
        str = strsplit(str, '#');
        pattern_str = str{1};
        stim_str = str{2};
        index = str2double(str{3});
        pattern_ind = cellfun(@(x) strcmp(x, pattern_str), obj.names);
        stim_ind = cellfun(@(x) strcmp(x, stim_str), obj.types);
        index_ind = index == obj.indexes;
        val = obj.stim_electrodes(pattern_ind & stim_ind & index_ind);
      end
    end
    
    function val = get_time(obj, amplitude)
      ind = sc_cellfind({obj.stim_electrodes.tag}, amplitude.tag);
      val = obj.stim_electrodes(ind).time;
    end
    
    function val = get.stim_electrodes(obj)
      val = obj.patterns(1).stim_electrodes;
      for i=2:length(obj.patterns)
        val(end+1:end+length(obj.patterns(i).stim_electrodes)) = ...
          obj.patterns(i).stim_electrodes;
      end
    end
    
    function val = get.names(obj)
      stims = obj.stim_electrodes;
      val = {stims.name};
    end
    
    function val = get.types(obj)
      stims = obj.stim_electrodes;
      val = {stims.type};
    end
    
    function val = get.indexes(obj)
      stims = obj.stim_electrodes;
      val = cell2mat({stims.index});
    end
  end
end