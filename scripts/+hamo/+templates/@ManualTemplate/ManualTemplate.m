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
    
    % Overriding hamo.templates.Template method
    function plotTriggerTimes(obj, hAxes, y, triggerTime, pretrigger, posttrigger)
      [~, tmp] = min(abs(triggerTime-obj.stimTimes));
      if all(isfinite(obj.responseTime(:, tmp)))
        plot(hAxes, obj.responseTime(1, tmp), y, '^');
        plot(hAxes, obj.responseTime(2, tmp), y, 'v');
      end
      plot(hAxes, [pretrigger posttrigger], y*[1 1], 'b-');
    end
    
    % Overriding hamo.templates.Template method
    function plotSweep(obj, hAxes, time, sweep, triggerTime)
      plotSweep@hamo.templates.Template(obj, hAxes, time, sweep);
      [~, tmp] = min(abs(triggerTime-obj.stimTimes));
      if all(isfinite(obj.responseTime(:, tmp)))
        plot(hAxes, obj.responseTime(1, tmp), obj.responseHeight(1, tmp), '^');
        plot(hAxes, obj.responseTime(2, tmp), obj.responseHeight(2, tmp), 'v');
      end
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