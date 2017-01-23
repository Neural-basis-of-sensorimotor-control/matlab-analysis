clc

clear

neurons = get_intra_neurons();
sc_dir = get_default_experiment_dir();
motifs = get_intra_motifs();
motifs = sort(motifs);

fprintf('\t');

for i=1:length(motifs)
  fprintf('%s\t', motifs{i});
end

fprintf('\n');

for i=1:length(neurons)
  neuron = neurons(i);
  fdir = [sc_dir neuron.experiment_filename];
  signal = sc_load_signal(fdir, neuron.file_tag, neuron.signal_tag);
  amplitudes = signal.amplitudes;

  fprintf('%s\t', neuron.file_tag);

  for j=1:length(motifs)
    amplitude = amplitudes.get('tag', motifs{j});
    if sc_amplitude_is_empty(amplitude)
      fprintf('empty\t');
    else
      fprintf('x\t');
    end
  end

  fprintf('\n');

end
