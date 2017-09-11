function set_waveform(obj, h_axes, waveform, indx)

if nargin < 4
  indx = 1;
end
  
obj.h_axes    = h_axes;
obj.waveform  = waveform;

if ~obj.waveform.n
  
  obj.threshold = ScThreshold([], [], [], []);
  obj.waveform.add(obj.threshold);
  
else
  
  obj.threshold = obj.waveform.get(indx);
  
end

end