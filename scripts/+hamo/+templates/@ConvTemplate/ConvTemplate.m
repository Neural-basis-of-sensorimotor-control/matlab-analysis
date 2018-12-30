classdef ConvTemplate < handle
  
  properties
    v
    lowerThreshold = .9
    upperThreshold = 1.11
    isUpdated = false
    indxDetected
  end
  
  methods
    
    function obj = ConvTemplate(v)
      obj.v = v;
    end
    
    function vConv = convolute(obj, vInput)
      vConv = conv(vInput, obj.v(length(obj.v):-1:1), 'same')/...
        sum(obj.v.^2);
    end
    
    function indx = match(obj, vInput)
      vConv = obj.convolute(vInput);
      localMax = diff(vConv(1:end-1)) > 0 & diff(vConv(2:end)) < 0;
      localMax = localMax & ...
        vConv(2:end-1) > obj.lowerThreshold & ...
        vConv(2:end-1) < obj.upperThreshold;
      indx = find(localMax) - length(obj.v);
    end
    
    function val = getTriggerTimes(obj, dt)
      val = obj.indxDetected*dt;
    end
  end
  
end