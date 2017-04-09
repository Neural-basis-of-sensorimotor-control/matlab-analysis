clear

max_inactivity_time = 10;
min_nbr_of_spikes_per_sequence = 5;
min_time_span_per_sequence = 2;

directory = ['D:' filesep 'temp' filesep 'analyzed_data' filesep];

files = List(1000);

for i=1:10
  s = rdir([directory '*.dat']);
  names = {s.name};
  
  for j=1:length(names)
    add(files, names(j));
  end
  
  directory = [directory '*' filesep]; %#ok<AGROW>
end

spiketrains = List(1000);
add_spiketrains(files, spiketrains);

overlapping_spiketrains = List(1000);
add_coupled_spiketrains(spiketrains, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_nbr_of_spikes_per_sequence, ...
  overlapping_spiketrains);
remove_identical_spiketrains(overlapping_spiketrains);
remove_identical_spiketrain_pairs(overlapping_spiketrains);

sc_dir = get_default_experiment_dir();
save([sc_dir 'overlapping_neurons'], 'overlapping_spiketrains');

%plot_overlapping_spiketrains(overlapping_spiketrains);
plot_raster_paired_recordings(overlapping_spiketrains);
