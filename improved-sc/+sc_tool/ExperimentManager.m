classdef ExperimentManager < sc_tool.SignalManager & ...
    sc_tool.TriggerManager
  
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
      
      if isempty(obj.m_file)
        
        obj.sequence = [];
        obj.signal1 = [];
        obj.signal2 = [];
        obj.triggerparents = [];
        
      else
        
        obj.sequence = get_set_val(obj.file.list, obj.sequence, 'full');
        
        obj.signal1 = get_set_val(obj.file.signals.list, obj.signal1, 'patch');
        
        if isempty(obj.signal2)
          obj.signal2 = get_set_val(obj.file.signals.list, obj.signal2, 'patch2');
        else
          obj.signal2 = [];
        end
        
        triggerparents = obj.get_triggerparents();
        
        obj.trigger_parent = get_set_val(triggerparents, obj.trigger_parent, ...
          sc_tool.EmptyClass());
        
      end
      
    end
    
    function val = get.sequence(obj)
      val = obj.m_sequence;
    end
    
    function set.sequence(obj, val)
      obj.m_sequence = val;
    end
    
  end
  
end