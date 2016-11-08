function update_amplitudes(obj, psp_templates, response_min, response_max, remove_fraction)

stims = get_intra_motifs();

s.smooth = true;
s.remove_artifacts = true;
s.remove_waveforms = true;
s.remove_artifacts_simple = true;

v = obj.get_v(s);

for i=1:length(stims)
  amplitude = obj.amplitudes.get('tag', stims{i});
  
  if ~amplitude.is_updated
    amplitude.update(v, obj.dt, psp_templates, response_min, response_max, remove_fraction);
  end
  
end

end