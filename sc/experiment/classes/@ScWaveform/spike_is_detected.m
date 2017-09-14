function val = spike_is_detected(obj, varargin)
% spike_is_detected(obj, v)
% spike_is_detected(obj, tmin, tmax)
% spike_is_detected(obj, tmin, tmax, min_isi_on)

narginchk(2, 4);

if length(varargin) == 1
  
  v = varargin{1};
  val = ~isempty(obj.match_v(v));
  
elseif length(varargin) >= 2
  
  tmin = varargin{1};
  tmax = varargin{2};
  
  if length(varargin) >= 3
    min_isi_on = varargin{3};
  else
    min_isi_on = false;
  end
  
  if min_isi_on
  
    val = ~isempty(obj.gettimes(tmin, tmax));
  
  else
    
    val = any(obj.detected_spiketimes >= tmin & obj.detected_spiketimes <= tmax) ...
      || any(obj.imported_spiketimes >= tmin & obj.imported_spiketimes <= tmax) ...
      || any(obj.predefined_spiketimes >= tmin & obj.predefined_spiketimes <= tmax);
  
  end
  
else
  
  error('Wrong number of inputs');

end

end