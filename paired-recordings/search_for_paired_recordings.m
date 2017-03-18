% Find all recordings with paired recordings
clear
sc_clf_all

neurons = concat_list(get_sssa_neurons(), get_intra_neurons);

max_inactivity_time = 10;
min_nbr_of_spikes_per_sequence = 5;
min_time_span_per_sequence = 2;

sc_dir = get_default_experiment_dir();


% %% Reset all experiments
% for i=1:length(neurons)
%   
%   fprintf('Reset: %d out of %d\n', i, length(neurons)); 
%   
%   neuron = neurons(i);
%   experiment_filename = neuron.experiment_filename;
%   experiment = ScExperiment.load_experiment([sc_dir experiment_filename]);
%   
%   if isempty(neuron.file_tag)
%     files = experiment.list;
%   else
%     files = get_items(experiment.list, 'tag', neuron.file_tag);
%   end
%   
%   for j=1:length(files)
%     
%     file = files(j);
%     waveforms = file.get_waveforms();
%     
%     if ~isempty(neuron.template_tag)
%        waveforms = get_items(waveforms, 'tag', neuron.template_tag);
%     end
%     
%     for k=1:file.signals.n
%       signal = file.signals.get(k);
%       signal.update_continuous_signal(true, waveforms);
%     end
%   end
%   
%   experiment.save_experiment(experiment.abs_save_path, false);
% end

%% Find paired neurons
paired_neurons = scan_for_paired_neurons(neurons, max_inactivity_time, ...
    min_nbr_of_spikes_per_sequence, min_time_span_per_sequence);

%% Plot results
reset_fig_indx();

for i=1:length(paired_neurons)
  
  fprintf('Plot paired neurons: %d out of %d\n', i, length(paired_neurons));
  
  incr_fig_indx();
  clf reset
  
  plot_paired_recordings(paired_neurons(i));
  
end

plot_raster_paired_recordings(paired_neurons);