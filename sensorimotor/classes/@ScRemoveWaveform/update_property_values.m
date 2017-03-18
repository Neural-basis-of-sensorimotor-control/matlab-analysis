function update_property_values(obj)

if isempty(obj.tstart)
  obj.tstart = -inf;
end

if isempty(obj.tstop)
  obj.tstop = inf;
end

if isempty(obj.apply_calibration)
  obj.apply_calibration = true;
end

if length(obj.stimpos) ~= length(obj.stimpos_offsets)
  obj.stimpos_offsets = zeros(size(obj.stimpos));
end

if isempty(obj.width)
  obj.v_median = [];
  obj.v_interpolated_median = [];
else
  if length(obj.v_median) ~= obj.width
    obj.v_median = zeros(obj.width,1);
  end
  if length(obj.v_interpolated_median) ~= obj.width+2
    obj.v_median = zeros(obj.width+2,1);
  end
end

if isfield(obj,'original_stimpos') && ~isempty(obj.original_stimpos)
  obj.original_stimtimes = obj.original_stimpos*obj.parent.dt;
  obj.original_stimpos = [];
end

end