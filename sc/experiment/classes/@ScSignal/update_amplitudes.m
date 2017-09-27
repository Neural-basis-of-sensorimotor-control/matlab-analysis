function update_amplitudes(signal, neuron, response_min, response_max, ...
  force_update)

stims = get_intra_motifs();

s.smooth                  = true;
s.remove_artifacts        = true;
s.remove_waveforms        = true;
s.remove_artifacts_simple = true;

v = signal.get_v(s);

for i=1:length(stims)
  
  fprintf('%g\n', i/length(stims));
  
  amplitude = signal.amplitudes.get('tag', stims{i});
  
  if force_update || ~amplitude.is_updated
  
    amplitude.update(v, signal.dt, neuron.template_tag, response_min, ...
      response_max);
  
  end
  
end

signal.update_spont_activity(neuron.template_tag, get_patterns(), ...
  response_min, response_max, neuron.tmin, neuron.tmax);

end