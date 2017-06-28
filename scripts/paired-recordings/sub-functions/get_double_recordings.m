function double_neuron = get_double_recordings(max_idle_time, experiment_file, file_tag, ...
  varargin)


experiment_file = [get_default_experiment_dir() experiment_file];

expr = ScExperiment.load_experiment(experiment_file);
file = expr.get('tag',file_tag);

waveforms = file.get_waveforms();

double_neuron(length(varargin)) = ScNeuron();
counter = 0;

disp(file_tag)

for i=1:(length(varargin)-1)
  if isempty(varargin{i+1})
    break
  end
  disp(varargin{i})
  
  waveform_1 = get_items(waveforms, 'tag', varargin{i});
  waveform_1.sc_loadtimes();
  
  t1 = waveform_1.gettimes(0, inf);
  sequence1 = get_sequence(t1, max_idle_time);
  
  for j=i+1:length(varargin)
    disp(varargin{j})
    
    if isempty(varargin{j})
      break
    end
    
    waveform_2 = get_items(waveforms, 'tag', varargin{j});
    waveform_2.sc_loadtimes();
    
    t2 = waveform_2.gettimes(0, inf);
    
    sequence2 = get_sequence(t2, max_idle_time);
    
    common_sequence = range_intersection(sequence1', sequence2');
    
    indx = 1:2:length(common_sequence);
    common_sequence = common_sequence([indx' indx'+1]);
    
    if ~isempty(common_sequence)
      
      counter = counter + 1;
      double_neuron(counter) = ScNeuron('experiment_filename', ...
        experiment_file, 'file_tag', file_tag, ...
        'template_tag', varargin([i j]), ...
        'time_sequences', common_sequence, ...
        'tag', file_tag);
      
    end
  end
end

double_neuron = double_neuron(1:counter);

end
