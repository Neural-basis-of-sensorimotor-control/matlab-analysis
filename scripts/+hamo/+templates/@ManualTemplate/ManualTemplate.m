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
    function plotTriggerTimes(obj, hAxes, y, triggerTimes, pretrigger, posttrigger)
      for i=1:length(triggerTimes)
        [~, tmp] = min(abs(triggerTimes(i)-obj.stimTimes));
        if all(isfinite(obj.responseTime(:, tmp)))
          offset = -triggerTimes(i) + obj.stimTimes(tmp);
          plot(hAxes, obj.responseTime(1, tmp) + offset, y, '^');
          plot(hAxes, obj.responseTime(2, tmp) + offset, y, 'v');
        end
      end
      plot(hAxes, [pretrigger posttrigger], y*[1 1], 'b-');
    end
    
    % Overriding hamo.templates.Template method
    function plotSweep(obj, hAxes, time, sweep, triggerTimes)
      plotSweep@hamo.templates.Template(obj, hAxes, time, sweep);
      for i=1:size(sweep, 2)
        [~, tmp] = min(abs(triggerTimes(i)-obj.stimTimes));
        if all(isfinite(obj.responseTime(:, tmp)))
          plot(hAxes, obj.responseTime(1, tmp), obj.responseHeight(1, tmp), '^');
          plot(hAxes, obj.responseTime(2, tmp), obj.responseHeight(2, tmp), 'v');
        end
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