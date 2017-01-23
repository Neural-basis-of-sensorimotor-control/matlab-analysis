% Find all recordings with paired recordings
clc
clear

paired_recordings;

min_nbr_of_overlapping_neurons = 40;

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
%     files = get_items(experiment, 'tag', neuron.file_tag);
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
paired_neurons = [];

for i=1:length(neurons)
  
  fprintf('Find paired neurons: %d out of %d\n', i, length(neurons));
  
  neuron = neurons(i);
  
  tmp_paired_neurons = get_paired_neurons(neuron, min_nbr_of_overlapping_neurons);
  
  paired_neurons = concat_list(paired_neurons, tmp_paired_neurons);

end

%% Plot results
for i=1:length(paired_neurons)
  
  fprintf('Plot paired neurons: %d out of %d\n', i, length(paired_neurons));
  
  figure(i)
  clf reset
  
  plot_paired_recordings(paired_neurons(i));
  
end