function [dist_measured, dist_shuffled] = intra_multinomial_2(neurons, ...
  response_min, response_max, plot_only_final_figures, nbr_of_simulations, str_stims)

stim_pulses = intra_get_multiple_stim_pulses(str_stims);

dist_measured = nan(length(stim_pulses), length(neurons));
dist_shuffled = nan(length(stim_pulses), length(neurons), nbr_of_simulations);

for i_set=1:length(stim_pulses)
  
  sc_debug.print(i_set, length(stim_pulses));
  
  permutations = 2.^(0:(stim_pulses(i_set).electrode_count-1));
  
  binary_permutations = get_binomial_permutations(stim_pulses(i_set).electrode_count);
  binary_permutations = logical(binary_permutations);
  
  pattern_str   = stim_pulses(i_set).pattern;
  electrode_str = stim_pulses(i_set).electrode;
  tmp_stims     = get_items(str_stims, @get_pattern, pattern_str);
  tmp_stims     = get_items(tmp_stims, @get_electrode, electrode_str);
  
  for i_neuron=1:length(neurons)
    
    sc_debug.print('set = ', i_set, '/', length(stim_pulses), 'neuron = ', i_neuron, ' /', length(neurons));
    
    % compute measured distribution
    measured_distribution = zeros(2^stim_pulses(i_set).electrode_count, 1);
    neuron                = neurons(i_neuron);
    
    signal     = sc_load_signal(neuron);
    templates  = get_items(signal.waveforms.list, 'tag', neuron.template_tag);
    amplitudes = get_items(signal.amplitudes.list, 'tag', tmp_stims);
    
    nbr_of_repetitions = min(cell2mat({arrayfun(@(x) length(x.valid_data), amplitudes)}));
    nbr_of_responses   = 0;
    
    for i_repetition=1:nbr_of_repetitions
      
      tmp_response = 0;
      
      for i_pulse=1:length(amplitudes)
        
        amplitude       = amplitudes(i_pulse);
        tmp_triggertime = amplitude.stimtimes(i_repetition);
        
        for i_template=1:length(templates)
          
          if templates(i_template).spike_is_detected(tmp_triggertime + response_min, ...
              tmp_triggertime + response_max)
            
            tmp_response = tmp_response + 2^(i_pulse-1);
            nbr_of_responses = nbr_of_responses + 1;
            continue
            
          end
        end
      end
      
      binary_response = dec2bin(tmp_response, stim_pulses(i_set).electrode_count) == '1';
      indx = find(all(repmat(binary_response, size(binary_permutations, 1), 1) == binary_permutations, 2));
      measured_distribution(indx) = measured_distribution(indx) + 1;
      
    end
    
    measured_distribution  = measured_distribution / sum(measured_distribution);
    mean_response_fraction = nbr_of_responses / (nbr_of_repetitions*length(amplitudes));
    
    nbr_of_positives = sum(binary_permutations, 2);
    nbr_of_negatives = stim_pulses(i_set).electrode_count - nbr_of_positives;
    
    ideal_distribution = mean_response_fraction.^nbr_of_positives .* (1 - mean_response_fraction).^nbr_of_negatives;
    dist_measured(i_set, i_neuron) = sqrt( sum( (measured_distribution - ideal_distribution).^2 ) );
    
    for i_simulation=1:nbr_of_simulations
      
      simulated_distribution = zeros(2^stim_pulses(i_set).electrode_count, 1);
      
      for i_repetition=1:nbr_of_repetitions
        
        tmp_response    = sum(permutations(rand(stim_pulses(i_set).electrode_count, 1) < mean_response_fraction));
        binary_response = dec2bin(tmp_response, stim_pulses(i_set).electrode_count) == '1';
        indx = find(all(repmat(binary_response, size(binary_permutations, 1), 1) == binary_permutations, 2));
        simulated_distribution(indx) = simulated_distribution(indx) + 1;
        
      end
      
      simulated_distribution = simulated_distribution / sum(simulated_distribution);
      dist_shuffled(i_set, i_neuron, i_simulation) = sqrt(sum( (simulated_distribution - ideal_distribution).^2 ));
      
    end
  end
end

end

