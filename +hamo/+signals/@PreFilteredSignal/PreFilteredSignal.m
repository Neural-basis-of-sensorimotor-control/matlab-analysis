classdef PreFilteredSignal < hamo.intra.Signal
  
  properties (Dependent)
    filtered_channel_path
  end
  
  properties
    lower_cutoff
    upper_cutoff
  end
  
  methods
    
    function obj = PreFilteredSignal(varargin)
      obj@hamo.intra.Signal(varargin{:});
    end
    
    function vRaw = getVRaw(obj)
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
    
    function filterData(obj, lower_cutoff, upper_cutoff)
      
      obj.lower_cutoff = lower_cutoff;
      obj.upper_cutoff = upper_cutoff;
      
      % [b,a] = butter(4, [obj.lower_cutoff obj.upper_cutoff]/(1/(2*obj.dt)), 'bandpass');
      % v = filter(b, a, obj.getVRaw());
      
      v = bandpass(obj.getVRaw(), [obj.lower_cutoff obj.upper_cutoff], ...
        1/obj.dt);
      
      if ~isfolder(fileparts(obj.filtered_channel_path))
        sc_settings.set_modified_raw_data_dir();
      end
      
      save(obj.filtered_channel_path, 'v');
      
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