clc

clear

neurons = get_neurons();
sc_dir = sc_get_sc_data_dir();
motifs = get_intra_motifs();
motifs = sort(motifs);

fprintf('\t');

for i=1:length(motifs)
  fprintf('%s\t', motifs{i});
end

fprintf('\n');

for i=1:length(neurons)
  neuron = neurons(i);
  fdir = [sc_dir neuron.expr_file];
  signal = sc_load_signal(fdir, neuron.file_str, neuron.signal_str);
  amplitudes = signal.amplitudes;
  
  fprintf('%s\t', neuron.file_str);
  
  for j=1:length(motifs)
    amplitude = amplitudes.get('tag', motifs{j});
    if sc_amplitude_is_empty(amplitude)
      fprintf('-\t');
    else
      fprintf('+\t');
    end
  end
  
  fprintf('\n');
  
end