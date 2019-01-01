classdef ConvTemplate < hamo.templates.Template
  
  properties
    shape
    triggerIndx
  end
  
  properties (Dependent)
    lowerThreshold
    upperThreshold
  end
  
  properties (SetAccess = 'private')
    m_lowerThreshold  = .9
    m_upperThreshold  = 1.11
  end
    
  methods
    
    function obj = ConvTemplate(shape, tag)
      obj.shape = shape;
      obj.tag   = tag;
    end
    
    function val = get.lowerThreshold(obj)
      val = obj.m_lowerThreshold;
    end
    
    function set.lowerThreshold(obj, val)
      obj.m_lowerThreshold = val;
      obj.isUpdated = false;
    end
    
    function val = get.upperThreshold(obj)
      val = obj.m_upperThreshold;
    end
    
    function set.upperThreshold(obj, val)
      obj.m_upperThreshold = val;
      obj.isUpdated = false;
    end
    
    function vCross = crossCorrelate(obj, vInput)
      vCross = conv(vInput, obj.shape(length(obj.shape):-1:1), 'same')/...
        sum(obj.shape.^2);
    end
    
    function indx = match_v(obj, vInput)
      vCross = obj.crossCorrelate(vInput);
      localMax = diff(vCross(1:end-1)) > 0 & diff(vCross(2:end)) < 0;
      localMax = localMax & ...
        vCross(2:end-1) > obj.lowerThreshold & ...
        vCross(2:end-1) < obj.upperThreshold;
      indx = find(localMax) - round(length(obj.shape)/2);
    end
    
    % Overriding hamo.templates.Template method
    function plotSweep(obj, hAxes, time, sweep)
      vCross = obj.crossCorrelate(sweep);
      plot(hAxes, time, vCross);
      line(hAxes, [time(1) time(end)], obj.lowerThreshold*[1 1]);
      line(hAxes, [time(1) time(end)], obj.upperThreshold*[1 1]);
      ylim(hAxes, [0 2]);
    end
    
    % Overriding hamo.templates.Template method
    function plotHandles = plotShape(obj, hAxes, t0, ~)
      holdIsOn = ishold(hAxes);
      plotHandles = plot(hAxes, t0 + (1:length(obj.shape))*obj.dt, obj.shape, ...
        'HitTest', 'off');
      if ~holdIsOn
        hold(hAxes, 'off');
      end
    end
    
    % Get trigger times, converted from array indices to continuous time
    %   obj hamo.templates.Template subclass
    function val = getTriggerTimes(obj)
      val = obj.triggerIndx*obj.dt;
    end
    
  end
  
end