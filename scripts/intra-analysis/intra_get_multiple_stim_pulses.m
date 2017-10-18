%% Select only electrodes with > 1 selected pulse
function stim_pulses = intra_get_multiple_stim_pulses(stims_str)

patterns_str = get_values(stims_str, @get_pattern);
unique_patterns_str = unique(patterns_str);

stim_pulses = [];

for i=1:length(unique_patterns_str)
  tmp_pattern = unique_patterns_str{i};
  
  tmp_stims_str = get_items(stims_str, @get_pattern, tmp_pattern);
  
  [tmp_electrodes, counts] = count_items_in_list(tmp_stims_str, @get_electrode);
  tmp_ind = counts>1;
  tmp_electrodes = tmp_electrodes(tmp_ind);
  tmp_counts = counts(tmp_ind);
  
  for j=1:length(tmp_electrodes)
    
    stim_pulses = add_to_list(stim_pulses, struct('pattern', tmp_pattern, ...
      'electrode', tmp_electrodes{j}, 'electrode_count', tmp_counts(j)));
    
  end
  
end

% Sort stim pulses
[~, ind1] = sort({stim_pulses.pattern});
stim_pulses = stim_pulses(ind1);

[~, ind1] = sort({stim_pulses.electrode});
stim_pulses = stim_pulses(ind1);

[~, ind1] = sort(cell2mat({stim_pulses.electrode_count}));
stim_pulses = stim_pulses(ind1);

end