function stop = sc_get_amplitude_pseudo_stop(gui, amplitude)
artifact_width = 1e-3;

if ~nnz(amplitude.valid_data)
  stop = [];
  return
end

stop_min = min(amplitude.data(amplitude.valid_data, 3));
stop_max = max(amplitude.data(amplitude.valid_data, 3));

stop = amplitude.data(:, 3);

signal = amplitude.parent_signal;
dt = signal.dt;
indx = find(~amplitude.valid_data); 
for i=1:length(indx)
  ind = indx(i);
  if stop_min == stop_max
    stop(ind) = stop_min;
    continue
  end
  tmp_start = amplitude.stimtimes(ind) + stop_min;
  tmp_stop = amplitude.stimtimes(ind) + stop_max;
  v = sc_get_sweeps(gui.main_channel.v, 0, amplitude.stimtimes(ind), ...
    stop_min, stop_max, dt);

  stims = amplitude.parent_signal.parent.stims;
  artifact_indx = false(size(v)); 
  for j=1:stims.n
    triggers = stims.get(j).triggers;
    for m=1:triggers.n
      times = triggers.get(m).gettimes(tmp_start, tmp_stop);
      for k=1:length(times)
        stim_start = round((times(k)-tmp_start)/amplitude.parent_signal.dt)+1;
        stim_stop = stim_start + round(artifact_width/amplitude.parent_signal.dt);
        stim_stop = min(stim_stop, length(v));
        artifact_indx(stim_start:stim_stop) = true;
      end
    end
  end
  v(artifact_indx) = -inf;
  [~, pos] = max(v);
  stop(ind) = stop_min + pos*dt;
end
