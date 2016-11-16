function update_amplitudes(obj, ic_tmin, ic_tmax, psp_templates, ...
  response_min, response_max, remove_fraction, force_update)

stims = get_intra_motifs();

s.smooth = true;
s.remove_artifacts = true;
s.remove_waveforms = true;
s.remove_artifacts_simple = true;

v = obj.get_v(s);

for i=1:length(stims)
  fprintf('%g\n', i/length(stims));
  amplitude = obj.amplitudes.get('tag', stims{i});
  
  if force_update || ~amplitude.is_updated
    amplitude.update(v, obj.dt, psp_templates, response_min, response_max, remove_fraction);
  end
  signal.user_data.spont_activity = automatic_psp_detection(obj, ...
    ic_tmin, ic_tmax, psp_templates, response_min, response_max);
end


end