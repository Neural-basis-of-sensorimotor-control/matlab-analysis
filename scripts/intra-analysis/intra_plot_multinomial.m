function intra_plot_multinomial...
  (shuffled_all_distributions, all_neuron_distribution, all_stat_distribution_multinomial_response, stim_pulses, neurons)

enc_pattern = {stim_pulses.pattern};

for i_pattern=1:length(enc_pattern)
  
  incr_fig_indx();
  clf
  
  ylim([0 (length(neurons)+1)])
  
  dist_measured           = nan(size(neurons));
  dist_simulated          = nan(size(neurons));
  dist_simulated_5_left   = nan(size(neurons));
  dist_simulated_5_right  = nan(size(neurons));
  dist_simulated_1_left   = nan(size(neurons));
  dist_simulated_1_right  = nan(size(neurons));
  dist_simulated_01_left  = nan(size(neurons));
  dist_simulated_01_right = nan(size(neurons));
  
  for i_neuron=1:length(neurons)
    
    tmp_measured_distribution  = all_neuron_distribution{i_pattern, i_neuron};
    tmp_ideal_distribution     = all_stat_distribution_multinomial_response{i_pattern, i_neuron};
    tmp_simulated_distribution = shuffled_all_distributions{i_pattern, i_neuron};
      
    tmp_dist_simulated_distribution = nan(size(tmp_simulated_distribution, 2), 1);
    
    for k=1:length(tmp_dist_simulated_distribution)
      tmp_dist_simulated_distribution(k) = sqrt( sum ( (tmp_simulated_distribution(:,k) - tmp_ideal_distribution) .^2) );
    end
    
    dist_measured(i_neuron)           = sqrt( sum ((tmp_measured_distribution - tmp_ideal_distribution).^2) );
    dist_simulated(i_neuron)          = median(tmp_dist_simulated_distribution);
    dist_simulated_5_left(i_neuron)   = prctile(tmp_dist_simulated_distribution, 2.5);
    dist_simulated_5_right(i_neuron)  = prctile(tmp_dist_simulated_distribution, 97.5);
    dist_simulated_1_left(i_neuron)   = prctile(tmp_dist_simulated_distribution, .5);
    dist_simulated_1_right(i_neuron)  = prctile(tmp_dist_simulated_distribution, 99.5);
    dist_simulated_01_left(i_neuron)  = prctile(tmp_dist_simulated_distribution, .05);
    dist_simulated_01_right(i_neuron) = prctile(tmp_dist_simulated_distribution, 99.95);
    
  end
    
  dummy_y = 1:length(neurons);
  h1 = plot(dist_measured, dummy_y, 'Tag', 'Measured distribution', 'LineWidth', 1, ...
    'Marker', 's', 'LineStyle', 'none', 'Color', 'b');
  
  hold on
  ylim([0 (length(neurons)+1)])
  
  h2 = plot(dist_simulated, dummy_y, 'Tag', 'median', 'LineWidth', 1, 'Marker', ...
    '^', 'LineStyle', 'none', 'Color', 'r');
  
  h3 = plot(dist_simulated_5_left, dummy_y, 'Tag', '5 % percentile', ...
    'LineStyle', '-', 'Color', 'r');
  plot(dist_simulated_5_right, dummy_y, 'Tag', '5 % percentile', ...
    'LineStyle', '-', 'Color', 'r')
  
  h4 = plot(dist_simulated_1_left, dummy_y, 'Tag', '1 % percentile', ...
    'LineStyle', '--', 'Color', 'r');
  plot(dist_simulated_1_right, dummy_y, 'Tag', '1 % percentile', ...
    'LineStyle', '--', 'Color', 'r')

  h5 = plot(dist_simulated_01_left, dummy_y, 'Tag', '0.1 % percentile', ...
    'LineStyle', ':', 'Color', 'r');
  plot(dist_simulated_01_right, dummy_y, 'Tag', '0.01 % percentile', ...
    'LineStyle', ':', 'Color', 'r')

  
  xl = xlim;
  xlim([0 xl(2)]);
  str_title = sprintf('%s (%d electrodes)', stim_pulses(i_pattern).pattern, ...
    stim_pulses(i_pattern).electrode_count);
  
  title(str_title);
  
  fprintf('%s %d %f\n', str_title, i_pattern, signrank(dist_simulated, dist_measured));
  
end

legend([h1 h2 h3 h4 h5], 'Measured', 'Simulated (median)', '5% percentile', '1% percentile', '0.1% percentile');

end
