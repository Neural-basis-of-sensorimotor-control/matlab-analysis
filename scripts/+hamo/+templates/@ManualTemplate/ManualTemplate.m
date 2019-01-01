classdef ManualTemplate < hamo.templates.Template
  
  properties
    stimTimes
    responseTime
    responseHeight
  end
  
  methods
    
    function obj = ManualTemplate(stimTimes, tag)
      obj.stimTimes      = stimTimes;
      dim                = [2, length(stimTimes)];
      obj.responseTime   = nan(dim);
      obj.responseHeight = nan(dim);
      obj.isUpdated      = true;
      obj.tag            = tag;
      obj.isTriggable    = true;
      obj.isEditable     = false;
    end
    
    % Implementing hamo.templates.Template abstract method
    function indx = match_v(obj, ~, varargin)
      indx = round(obj.triggerTimes/obj.dt);
    end
 
    % Implementing hamo.templates.Template abstract method
    function times = getTriggerTimes(obj)
      validData = all(isfinite(obj.responseTime), 1);
      times = obj.stimTimes(validData) + obj.responseTime(1, validData);
    end
    
    function addStimResponse(obj, stimTime, time, height)
      [~, tmp] = min(abs(stimTime-obj.stimTimes));
      obj.responseTime(:, tmp)   = time;
      obj.responseHeight(:, tmp) = height;
    end
    
    
  end
  
  methods (Access = 'protected')
    
    function changeParentNotifier(obj)
      obj.isUpdated = true;
    end
    
  end
end