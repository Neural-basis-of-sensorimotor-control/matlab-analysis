function at_least_one_plot = plot_several_patterns(fig, neurons, scaling_dim)

figure(fig);
clf reset
at_least_one_plot = false;

stims = get_intra_motifs();
patterns = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);

if ischar(neurons)
  neurons = get_intra_neurons(neurons);
elseif iscell(neurons) && ~isempty(neurons) && ischar(neurons{1})
  neurons = get_intra_neurons(neurons);
end


for i=1:length(unique_patterns)
  fprintf('Pattern %d out of %d\n', i, length(unique_patterns));
  pattern = unique_patterns{i};
  stim = stims(equals(patterns, pattern));
  
  responses = nan(length(stim), 0);
  neuron_tags = {};
  
  for j=1:length(neurons)
    neuron = neurons(j);
    
    signal = sc_load_signal(neuron);
    
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    nbr_of_repetitions = min(cell2mat({arrayfun(@(x) length(x.valid_data), amplitudes)}));
    
    tmp_responses = zeros(length(amplitudes), nbr_of_repetitions);
    single_pulses = cell2mat(get_values(amplitudes, @get_epsp_amplitude_single_pulse));
    
    for k=1:length(amplitudes)
      tmp_responses(k,:) = amplitudes(k).data(1:nbr_of_repetitions, 4) - ...
        amplitudes(k).data(1:nbr_of_repetitions, 2)./single_pulses(k);
      
    end
    
    tmp_responses(:, all(isnan(tmp_responses))) = [];
    tmp_responses(isnan(tmp_responses)) = 0;
    
    responses = [responses tmp_responses];  %#ok<AGROW>
    
    dummy_cell = cell(size(tmp_responses,2),1);
    tmp_neuron_tags = cellfun(@(x) neuron.file_tag, dummy_cell, 'UniformOutput', false);
    neuron_tags = [neuron_tags; tmp_neuron_tags]; %#ok<AGROW>
    %     valid_repetitions = true(nbr_of_repetitions, 1);
    %
    %     for k=1:nbr_of_repetitions
    %       for m=1:length(amplitudes)
    %
    %         if ~amplitudes(m).valid_data(k)
    %           valid_repetitions(k) = false;
    %           continue
    %         end
    %       end
    %     end
    
    %     valid_repetitions = find(valid_repetitions);
    %
    %     if length(valid_repetitions)<3
    %       continue
    %     else
    %       at_least_one_plot = true;
    %     end
    %
    %     responses = nan(length(amplitudes), length(valid_repetitions));
    %     for k=1:length(valid_repetitions)
    %       tmp_response = nan(1, length(amplitudes));
    %
    %       for m=1:length(amplitudes)
    %         tmp_response(m) = amplitudes(m).data(valid_repetitions(k),4) - ...
    %           amplitudes(m).data(valid_repetitions(k),2);
    %       end
    %
    %       responses(:,k) = tmp_response;
    %     end
    
  end
  
  if size(responses,2)<3
    continue
  else
    at_least_one_plot = true;
  end
  
  d = pdist(responses');
  y = cmdscale(d, scaling_dim);
  
  sc_square_subplot(length(unique_patterns), i);
  plot_mda(y, neuron_tags)
  
  titlestr = unique_patterns{i};

  if length(neurons) == 1
    titlestr = [titlestr ' (' neurons.file_tag ')']; %#ok<AGROW>
  end
    
  title(titlestr);
end


if length(neurons) > 1
  add_legend(get_axes(), true);
end