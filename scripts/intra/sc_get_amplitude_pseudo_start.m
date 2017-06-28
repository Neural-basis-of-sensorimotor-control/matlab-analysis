function start = sc_get_amplitude_pseudo_start(amplitude)

if ~nnz(amplitude.valid_data)
  start = [];
  return
end

start = min(amplitude.data(amplitude.valid_data, 1));
start = repmat(start, size(amplitude.data,1), 1);
start(amplitude.valid_data) = amplitude.data(amplitude.valid_data, 1);

