classdef ExperimentViewer < handle
  
  properties (Dependent)
    Experiment
    File
    Sequence
  end
  
  properties (SetAccess=private, SetObservable)
    experiment
    file
    sequence
  end
  
  properties (Abstract)
    Signal1
  end
  
  methods
    function t = get.Experiment(obj)
      t = obj.experiment;
    end
    
    function set.Experiment(obj, t)
      obj.experiment = t;
      obj.File = viewer.util.get_new_child(t, obj.File);
    end
    
    function t = get.File(obj)
      t = obj.file;
    end
    
    function set.File(obj, t)
      obj.file = t;
      obj.Sequence = viewer.util.get_new_child(t, obj.Sequence);
    end
    
    function t = get.Sequence(obj)
      t = obj.sequence;
    end
    
    function set.Sequence(obj, t)
      obj.sequence = t;
      if isempty(t)
        obj.Signal1 = [];
      else
        obj.Signal1 = viewer.util.get_new_child(t.signals, obj.File);
      end
    end
    
  end
end