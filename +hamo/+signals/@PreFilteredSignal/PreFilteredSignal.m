classdef PreFilteredSignal < hamo.intra.Signal
  
  properties (Dependent)
    filtered_channel_path
  end
  
  properties
    isUpdated = false
  end
  
  properties (Dependent)
    lower_cutoff
    upper_cutoff
  end
  
  properties (SetAccess = 'private', GetAccess = 'private')
    m_lower_cutoff = 15
    m_upper_cutoff = 1e4
  end
  
  methods
    
    function obj = PreFilteredSignal(varargin)
      obj@hamo.intra.Signal(varargin{:});
    end
    
    function vRaw = getVRaw(obj)
      %vRaw = obj.get_v(false, true, false, false);
      vRaw = obj.get_v(false, true, false, false);
    end
    
    function v = getV(obj)
      s = load(obj.filtered_channel_path);
      v = s.v;
    end
    
    function val = get.filtered_channel_path(obj)
      [~, expr_name] = fileparts(obj.parent.parent.save_name);
      val = [sc_settings.get_modified_raw_data_dir() expr_name '_' obj.parent.tag '_' obj.tag '.mat'];
    end
    
    function filterData(obj)
      
      [b, a] = butter(2, 2*[obj.lower_cutoff obj.upper_cutoff]/1e5, 'bandpass');
      v = filter(b, a, obj.getVRaw());
      
      if ~isfolder(fileparts(obj.filtered_channel_path))
        sc_settings.set_modified_raw_data_dir();
      end
      
      save(obj.filtered_channel_path, 'v');
      obj.isUpdated = true;
      
    end
    
    function val = get.lower_cutoff(obj)
      val = obj.m_lower_cutoff;
    end
    
    function set.lower_cutoff(obj, val)
      is_changed = obj.lower_cutoff ~= val;
      obj.m_lower_cutoff = val;
      
      if is_changed
        obj.isUpdated = false;
      end
    end
    
    function val = get.upper_cutoff(obj)
      val = obj.m_upper_cutoff;
    end
    
    function set.upper_cutoff(obj, val)
      is_changed = obj.upper_cutoff ~= val;
      obj.m_upper_cutoff = val;
      
      if is_changed
        obj.isUpdated = false;
      end
    end
    
  end
  
  methods (Static)
    
    function obj = loadFromScNeuron(neuron)
      obj = hamo.intra.loadSignal(neuron);
      obj = hamo.signals.PreFilteredSignal.clone(obj);
    end
    
    function newClass = clone(oldClass)
      newClass = hamo.signals.PreFilteredSignal(oldClass.parent, ...
        oldClass.channelname);
      hamo.util.clone(oldClass, newClass);
    end
    
  end
end