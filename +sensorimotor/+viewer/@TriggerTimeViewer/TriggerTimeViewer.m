classdef TriggerTimeViewer < handle
  
  properties (Dependent)
    TriggerParent
    Trigger
    TriggerIndx
    TriggerTime
  end
  
  properties (SetAccess=private, SetObservable)
    triggerParent
    trigger
    triggerIndx
    triggerTime
  end
  
  properties (SetAccess=private)
    triggerTimes
  end
  
  properties (Abstract)
    PlotMode
  end
  
  methods (Abstract)
    varargout = updatePlot(varargin)
  end
  
  methods
    
    function t = get.TriggerParent(obj)
      if obj.PlotMode == 'AmplitudeMode'
        t = obj.Signal1;
      else
        t = obj.triggerParent;
      end
    end
    
    function set.TriggerParent(obj, t)
      obj.triggerParent = t;
      if isempty(t)
        obj.Trigger = [];
      elseif isa(t, 'EmptyClassPlaceHolder')
        obj.Trigger = [];
        %       elseif obj.PlotMode == 'AmplitudeMode'
        %         obj.Trigger = sensorimotor.util.get_new_child(obj.TriggerParent, obj.Amplitude);
        %       else
        obj.Trigger = sensorimotor.util.get_new_child(obj.TriggerParent, obj.Trigger);
      end
    end
    
    function t = get.Trigger(obj)
      %       if obj.PlotMode == 'AmplitudeMode'
      %         t = obj.Amplitude;
      %       else
      t = obj.trigger;
      % end
    end
    
    function set.Trigger(obj, t)
      %       if obj.PlotMode == 'AmplitudeMode'
      %         obj.Amplitude
      %       else
      obj.trigger = t;
      if isempty(t) || isa(t, 'EmptyClassPlaceHolder')
        obj.triggerTimes = [];
        obj.TriggerIndx = [];
      else
        obj.triggerTimes = t.get_times(obj.sequence.tmin, obj.sequence.tmax);
        obj.TriggerIndx = get_set_val(1:length(obj.triggerTimes), obj.TriggerIndx, 1);
      end
      %     end
    end
    
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