% % Constants
% min_nbr_of_common_spikes = 100;
% 
% % Initialize
% reset_fig_indx();
% 
% % Main
% neurons = find_overlapping_neurons(min_nbr_of_common_spikes);
% 
% paired_plot_raster(neurons);

print_neurons(neurons);

% Functions

function neurons = find_overlapping_neurons(min_nbr_of_common_spikes)

sc_dir = get_default_experiment_dir();

experiments_str = ls(sprintf('%s*_sc.mat', sc_dir));

neurons(100) = ScNeuron;
counter      = 0;

for i=1:size(experiments_str, 1)
  
  debug_printout(mfilename, i, size(experiments_str, 1));
  
  experiment_str = experiments_str(i, :);
  
  experiment = ScExperiment.load_experiment(sprintf('%s%s', sc_dir, experiment_str));
  
  for i_file = 1:experiment.n
    
    file = experiment.get(i_file);
    
    if file.signals.has('tag', 'patch')
      
      signal = file.signals.get('tag', 'patch');
      [neurons, counter] = scan_signal(signal, neurons, counter, min_nbr_of_common_spikes);
      
    end
    
    if file.signals.has('tag', 'patch2')
      
      signal = file.signals.get('tag', 'patch2');
      [neurons, counter] = scan_signal(signal, neurons, counter, min_nbr_of_common_spikes);
      
    end
    
  end
  
end

neurons = neurons(1:counter);

end


function print_neurons(neurons)

fprintf('data = {\n');

for i_neuron=1:length(neurons)
  
  neuron = neurons(i_neuron);
  
  fprintf('\t''%s''', strtrim(neuron.experiment_filename))
  fprintf('\t''%s''', neuron.file_tag)
  fprintf('\t''%s''', neuron.signal_tag)
  fprintf('\t''%s''', neuron.tmin)
  fprintf('\t''%s''', neuron.tmax)
  fprintf('\t{''%s'' ''%s''}', neuron.template_tag{:})
  
  fprintf('\t...\n');
  
end

fprintf('};\n');

end

function [neurons, counter] = scan_signal(signal, neurons, counter, min_nbr_of_common_spikes)

signal.sc_loadtimes();

waveforms = signal.waveforms;

for i_waveform = 1:waveforms.n-1
  
  waveform_1 = waveforms.get(i_waveform);
  
  if is_psp(waveform_1.tag)
    continue
  end
  
  t1 = waveform_1.gettimes(0, inf);
  
  if isempty(t1)
    continue
  end
  
  for j_waveform = i_waveform+1:waveforms.n
    
    waveform_2 = waveforms.get(j_waveform);
    
    if is_psp(waveform_2.tag)
      continue
    end
    
    t2 = waveform_2.gettimes(0, inf);
    
    if isempty(t2)
      continue
    end
    
    tmin = max(min(t1), min(t2));
    tmax = min(max(t1), max(t2));
    
    t1_ = t1(t1>tmin&t1<tmax);
    t2_ = t2(t2>tmin&t2<tmax);
    
    if length(t1_) >= min_nbr_of_common_spikes && ...
        length(t2_) >= min_nbr_of_common_spikes
      
      neuron = ScNeuron(...
        'experiment_filename',  waveform_1.parent.parent.parent.save_name, ...
        'file_tag',             waveform_1.parent.parent.tag, ...
        'signal_tag',           waveform_1.parent.tag, ...
        'template_tag',         {waveform_1.tag waveform_2.tag}, ...
        'tmin',                 tmin, ...
        'tmax',                 tmax);
      
      counter          = counter + 1;
      neurons(counter) = neuron;
      
    end
    
  end
  
end

end


function val = is_psp(tag)

val = ~isempty(strfind(tag, '-psp-')) || ~isempty(strfind(tag, 'EPSP'));

end
