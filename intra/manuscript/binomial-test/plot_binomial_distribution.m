function plot_binomial_distribution(neurons, response_min, response_max)
%plot_binomial_distribution(neurons, response_min, response_max)
%Example: plot_binomial_distribution({'HRNR0000', 'ICNR0002', 'ICNR0003'}, ...
%  4e-3, 22e-3);
%

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
  tmp_stims = stims(equals(patterns, pattern));
  
  [bin_perm, nbr_of_positives] = get_binomial_permutations(length(tmp_stims));
  bin_perm = logical(bin_perm);
  
  xtick = nan(size(nbr_of_positives));
  xticklabel = cell(size(xtick));
  unique_xtick = unique(nbr_of_positives);
  yvalues = nan(size(xtick,1), length(neurons));
 
  for j=1:length(unique_xtick)
    indx = find(nbr_of_positives == unique_xtick(j));
    
    dx = .9/length(indx)*( 0:(length(indx)-1))';
    dx = dx - mean(dx);
    
    xtick(indx) = unique_xtick(j) + dx;
        
    for k=1:length(indx)
      xticklabel(indx(k)) = {num2str(bin_perm(indx(k),:))};
    end
  end
  
  
  for j=1:length(neurons)    
    neuron = neurons(j);
    
    signal = sc_load_signal(neuron);
    templates = get_items(signal.waveforms.list, 'tag', neuron.template_tag);
    
    amplitudes = get_items(signal.amplitudes.list, 'tag', tmp_stims);
    
    nbr_of_repetitions = min(cell2mat({arrayfun(@(x) length(x.valid_data), amplitudes)}));
    
    tmp_values = false(nbr_of_repetitions, length(amplitudes));
    
    for k=1:nbr_of_repetitions
      
      for m=1:length(amplitudes)
        amplitude = amplitudes(m);
        tmp_triggertime = amplitude.stimtimes(k);
        
        for n1=1:length(templates)
          if templates(n1).spike_is_detected(tmp_triggertime + response_min, ...
              tmp_triggertime + response_max)
            tmp_values(k, m) = true;
            continue
          end
        end
      end
    end
    
    tmp_distribution = zeros(size(bin_perm,1), 1);
    
    for k=1:length(tmp_distribution)
      for m=1:size(tmp_values,1)
        if all(tmp_values(m,:) == bin_perm(k,:))
          tmp_distribution(k) = tmp_distribution(k) + 1;
        end
      end
    end
    
    yvalues(:, j) = tmp_distribution/sum(tmp_distribution);
  end
  
  incr_fig_indx();
  clf reset
  bar(xtick, yvalues);
  set(gca, 'XTick', xtick, 'XTickLabel',xticklabel,'XTickLabelRotation', 270)
  title(['Response distribution for pattern ' pattern]);
  legend({neurons.file_tag});
end




