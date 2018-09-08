classdef TriggerTimeViewer < handle
  
  properties (Dependent)
    TriggerIndx
    TriggerTime
  end
  
  properties (SetAccess=private, SetObservable)
    triggerIndx
    triggerTime
  end
  
  properties (SetAccess=private)
    triggerTimes
  end
  
  properties (Abstract)
    PlotMode
    TriggerParent
    Trigger
  end
  
  methods (Abstract)
    varargout = updatePlot(varargin)
  end
  
  methods

    function t = get.TriggerIndx(obj)
      t = obj.triggerIndx;
    end
    
    function set.TriggerIndx(obj, t)
      obj.triggerIndx = mod(t-1, length(obj.triggerTimes))+1;
      if ~isempty(t)
        obj.TriggerTime = obj.triggerTimes(obj.TriggerIndx);
      end
    end
    
    function t = get.TriggerTime(obj)
      t = obj.triggerTime;
    end
    
    function set.TriggerTime(obj, t)
      obj.triggerTime = t;
      obj.updatePlot();
    end
  end
end