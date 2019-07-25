classdef AutoThresholdTemplate < ScThreshold & hamo.templates.Template
  %Currently no auto-update of isUpdated when changing threshold values
  
  properties
    shape
    triggerIndx
  end
  
  methods
    
    function obj = AutoThresholdTemplate(shape, tag)
      
      
      nbr_of_thresholds    = 7;
      min_tolerance_ratio  = .1;
      max_tolerance_ratio  = .3;
      
      tolerance_ratio_to_peak_value = min_tolerance_ratio + ...
        (max_tolerance_ratio - min_tolerance_ratio) * ...
        (0:(nbr_of_thresholds-1));
      
      
      shape_width  = length(shape);
      
      shape        = shape - shape(1);
      [max_deviation, ind_max] = max(abs(shape));
      
      if nbr_of_thresholds > 1
        pos_offset_step = round(shape_width/(nbr_of_thresholds-1));
        pos_offset      = (1:(nbr_of_thresholds-1))'*pos_offset_step;
      else
        pos_offset      = [];
      end
      pos_offset(end+1) = ind_max;
      tolerance         = abs(max_deviation) * tolerance_ratio_to_peak_value;
      
      
      obj@ScThreshold(indx, shape(pos_offset), shape(pos_offset)-tolerance, ...
        shape(pos_offset)+tolerance);
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
          v0 + obj.v_offset(i) + [obj.lower_tolerance(i) obj.upper_tolerance(i)], ...
          'Marker', '+', 'LineStyle', '-', 'HitTest', 'off');
        plotHandles = add_to_list(plotHandles, h);
        h = plot(hAxes, t0, v0, 'Marker', 's');
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