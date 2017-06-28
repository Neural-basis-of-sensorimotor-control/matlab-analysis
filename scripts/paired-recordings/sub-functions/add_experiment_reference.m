function add_experiment_reference(spiketrain)

if isa(spiketrain, 'List')
  
  for i=1:len(spiketrain)
    add_experiment_reference(spiketrain(i));
  end
  
  return
end

if isa(spiketrain, 'ScSpikeTrainCluster')
  
  for i=1:length(spiketrain.neurons)
    add_experiment_reference(spiketrain.neurons(i));
  end
  
  return
end

sc_dir = get_default_experiment_dir();

experiment_name = spiketrain.file_tag(1:4);

if isfile([sc_dir experiment_name '_SSSA_sc.mat'])
  spiketrain.experiment_filename = [experiment_name '_SSSA_sc.mat'];
elseif isfile([sc_dir experiment_name '_sc.mat'])
  spiketrain.experiment_filename = [experiment_name '_sc.mat'];
else
  error('Could not find experiment %s', experiment_name);
end

end
