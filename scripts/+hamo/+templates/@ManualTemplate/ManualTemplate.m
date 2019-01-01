classdef ManualTemplate < hamo.templates.Template
  
  properties
    xData
    yData
  end
  
  properties
    %Inherited from hamo.templates.Template class
    isTriggable    = true
    isEditable     = false
  end
  
  methods
    
    function obj = ManualTemplate(parent, triggerTimes, tag)
      obj.parent      = parent;
      obj.triggerIndx = round(triggerTimes/obj.dt);
      dim             = [2, length(obj.triggerIndx)];
      obj.xData       = nan(dim);
      obj.yData       = nan(dim);
      obj.isUpdated   = true;
      obj.tag         = tag;
    end
    
    % Overriding hamo.templates.Template method
    function indx = match_v(obj, ~, varargin)
      indx = obj.triggerIndx;
    end
    
    % Overriding hamo.templates.Template method
    function times = getTriggerTimes(obj)
      validData = all(isfinite(obj.xData), 1);
      times = obj.dt*(obj.triggerIndx(validData) + obj.xData(1, validData));
    end
    
    function addTriggerResponse(obj, triggerTime, responseTime, responseAmplitude)
      [~, tmp] = min(abs(round(triggerTime/obj.dt)-obj.triggerIndx));
      obj.xData(tmp, :) = round(responseTime/obj.dt);
      obj.yData(tmp, :) = responseAmplitude;
    end
    
    
  end
  
  methods (Access = 'protected')
    
    function changeParentNotifier(obj)
      obj.isUpdated = true;
    end
    
  end
end