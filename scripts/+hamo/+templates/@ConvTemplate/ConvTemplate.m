classdef ConvTemplate < handle
  
  properties
    v
    lowerThreshold = .9
    upperThreshold = 1.11
  end
  
  methods
    
    function obj = ConvTemplate(v)
      obj.v = v;
    end
    
    function vConv = convolute(obj, v)
      vConv = conv(v, obj.v(length(obj.v):-1:1), 'same')/...
                sum(obj.v.^2);
    end
    
    function indx = match(obj, v)
      vConv = obj.convolute(v);
      localMax = diff(vConv(1:end-1)) > 0 & diff(vConv(2:end)) < 0;
      localMax = localMax & ...
        vConv(2:end-1) > obj.lowerThreshold & ...
        vConv(2:end-1) < obj.upperThreshold;
      indx = find(localMax);
    end
  end
  
end