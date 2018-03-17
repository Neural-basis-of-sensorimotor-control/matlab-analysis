classdef ExperimentManager < SignalManager & TriggerManager
  
  properties (Dependent)
    experiment
    file
    sequence
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_experiment
    m_file
    m_sequence
  end
  
  methods
    
    function val = get.experiment(obj)
      val = obj.m_experiment;
    end
    
    function set.experiment(obj, val)
      
      obj.m_experiment = val;
      obj.file = get_set_val(obj.experiment.list, obj.file, 1);
      
    end
    
    function val = get.file(obj)
      val = obj.m_file;
    end
    
    function set.file(obj, val)
      
      obj.m_file = val;
      
      obj.sequence = get_set_val(obj.file.list, obj.sequence, 'full');
            
      obj.signal1 = get_set_val(obj.file.signals.list, obj.signal1, 'patch');
      
      if isempty(obj.signal2)
        obj.signal2 = get_set_val(obj.file.signals.list, obj.signal2, 'patch2');
      else
        obj.signal2 = [];
      end
      
      tmin = obj.sequence.tmin;
      tmax = obj.sequence.tmax;
      
      triggerparents = obj.sequence.gettriggerparents(tmin, tmax);
      triggerparents = triggerparents.cell_list;
      triggerparents = concat_list({EmptyClass()}, triggerparents);
      
      if ~isempty(obj.signal1.amplitudes.list)
        
        amplitude_token = EmptyClass();
        amplitude_token.source = obj.signal1;
        triggerparents = add_to_list(triggerparents, amplitude_token);
        
      end
      
      obj.trigger_parent = get_set_val(triggerparents, obj.trigger_parent, ...
        EmptyClass());
      
    end
    
    function val = get.sequence(obj)
      val = obj.m_sequence;
    end
    
    function set.sequence(obj, val)
      obj.m_sequence = val;
    end
    
  end
  
end