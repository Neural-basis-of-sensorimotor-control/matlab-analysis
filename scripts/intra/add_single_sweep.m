function add_single_sweep()

sc_dir = get_default_experiment_dir();

experiment_file = [sc_dir 'IDNR_sc.mat'];
file_tag = 'IDNR0001';
channel_str = 'patch';

signal = add_single_sweep_subfct(experiment_file, file_tag, channel_str);

signal.sc_save(true);

end

function signal = add_single_sweep_subfct(experiment_file, file_tag, channel_str)

tmin = -inf; tmax = inf;

dummy_sequence.tmin = tmin; dummy_sequence.tmax = tmax;

neuron = ScNeuron('experiment_filename', experiment_file, 'file_tag', ...
  file_tag, 'signal_tag', channel_str);

signal = sc_load_signal(neuron);
file = signal.parent;
file.sc_loadtimes();
textmark = file.textchannels.get('tag','TextMark');
textmark.sc_loadtimes();
amplitudes = signal.amplitudes;

for i=1:4
  stim_str = ['V' num2str(i)];
  single_pulse_stim_strs = get_single_amplitudes(num2str(i));
  pattern_str = sprintf('1p electrode %d', i);
  pattern = textmark.triggers.get('tag', pattern_str);
  pattern_times = pattern.gettimes(tmin, tmax);
  t_start = pattern_times(1); t_stop = pattern_times(1)+1;
  stim = file.stims.get('tag', stim_str).triggers.get(1);
  stim_times = stim.gettimes(tmin, tmax);
  stim_times = stim_times(stim_times > t_start & stim_times < t_stop);
  stim_inds = 1:length(stim_times);
  
  for j=1:length(stim_inds)
    str = single_pulse_stim_strs{j};
    
    if amplitudes.has('tag', str)
      warning('Amplitude %s already in list', str);
    else
      offset = stim_times(j) - t_start;
      amplitudes.add(ScAmplitude(dummy_sequence, signal, pattern, ...
          {'t1','v1','t2','v2'}, str, offset));
    end
  end
end

[~, ind] = sort(amplitudes.values('tag'));
amplitudes.cell_list = amplitudes.cell_list(ind);  

end