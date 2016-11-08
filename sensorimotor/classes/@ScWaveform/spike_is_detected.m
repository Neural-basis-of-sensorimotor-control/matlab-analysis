function val = spike_is_detected(obj, varargin)

if length(varargin) == 1
  v = varargin{1};
  val = ~isempty(obj.match_v(v));
elseif length(varargin) == 2
  tmin = varargin{1};
  tmax = varargin{2};
  
  val = any(obj.detected_spiketimes >= tmin & obj.detected_spiketimes <= tmax) ...
    || any(obj.imported_spiketimes >= tmin & obj.imported_spiketimes <= tmax) ...
    || any(obj.predefined_spiketimes >= tmin & obj.predefined_spiketimes <= tmax);
else
  error('Wrong number of inputs');
end

end