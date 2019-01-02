classdef AutoThresholdTemplate < ScThreshold & hamo.templates.Template
  %Currently no auto-update of isUpdated when changing threshold values
  
  properties
    shape
    triggerIndx
  end
  
  methods
    
    function obj = AutoThresholdTemplate(shape, tag)
      shape = shape - shape(1);
      [~, ind] = max(abs(shape));
      
      N = length(shape);
      if ind<0.2*N || ind>.8*N
        indx = round((1:7)'*(N/7));
        indx = [ind; indx];
      else
        indx = ind;
        indx = concat_list(indx, round((1:3)*ind/4));
        indx = concat_list(indx, ind + round(1:3)*(N-ind)/4);
      end
      percentageTolerance = .05 + .1 * (0:(length(indx)-1))'/(length(indx)-1);
      [~, tmpIndx] = sort(indx);
      tolerance = percentageTolerance;
      tolerance(tmpIndx) = percentageTolerance(tmpIndx) .* abs(shape(indx(tmpIndx)));
      obj@ScThreshold(indx, shape(indx), shape(indx)-tolerance, shape(indx)+tolerance);
      obj.shape = shape;
      obj.tag   = tag;
    end
    
    % Overriding hamo.templates.Template method
    function plotHandles = plotShape(obj, hAxes, t0, v0)
      holdIsOn = ishold(hAxes);
      hold(hAxes, 'on')
      plotHandles = [];
      for i=1:obj.n
        h = plot(hAxes, t0 + obj.position_offset(i)*obj.dt*[1 1], ...
          v0 + [obj.lower_tolerance(i) obj.upper_tolerance(i)], ...
          'Marker', '+', 'LineStyle', '-', 'HitTest', 'off');
        plotHandles = add_to_list(plotHandles, h);
      end
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