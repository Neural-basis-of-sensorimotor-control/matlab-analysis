function intra_compare_simulated_to_measured_multinomial_distribution(neuron, ...
  response_min, response_max, stim_pulse, h_figure)
%Compute P value for simulated multinomial distribution with sampling error

sc_print.set_mode(true);
 
stims_str = get_intra_motifs();

if nargin < 4

  stim_pulse = intra_get_multiple_stim_pulses(stims_str);
  vectorize_fcn(@(x) intra_compare_simulated_to_measured_multinomial_distribution(neuron, response_min, response_max, x), stim_pulse);
  
  return

end

if nargin < 5
  
  h_figure = incr_fig_indx();
  clf
  hold on
  set(gca, 'YTick', 1:length(neuron), 'YTickLabel', {neuron.file_tag});
  xlabel('Euclidean distance')
  ylabel('Neuron')
  title(sprintf('Pattern: %s, electrode: %s, nbr of stimulations: %d', stim_pulse.pattern, ...
    stim_pulse.electrode, stim_pulse.electrode_count));
  grid on
  
  sc_print.print(stim_pulse.pattern, stim_pulse.electrode, ...
    stim_pulse.electrode_count);
  set_counter(0);

end

if length(neuron) ~= 1
  
  vectorize_fcn(@intra_compare_simulated_to_measured_multinomial_distribution, ...
    neuron, response_min, response_max, stim_pulse, h_figure);
  return
  
end

increment_counter();
normalize = true;

pattern_str           = stim_pulse.pattern;
electrode_str         = stim_pulse.electrode;
tmp_stims             = get_items(stims_str, @get_pattern, pattern_str);
tmp_stims             = get_items(tmp_stims, @get_electrode, electrode_str);

nbr_of_simulations    = 1e4;

[measured_distribution, measured_permutations, nbr_of_positives, ...
  avg_response_rate, ~, response_profiles] = ...
  get_binomial_distribution(neuron, tmp_stims, response_min, response_max, ...
  normalize);

ideal_distribution    = get_stochastic_binomial_distribution(nbr_of_positives, avg_response_rate);

d_measured         = sqrt(sum((ideal_distribution - measured_distribution).^2));
n_measured_further_away_than_shuffled = 0;
n_measured_closer_than_shuffled = 0;

plot(d_measured*[1 1], get_counter() + [-.5 .5]);

for i=1:nbr_of_simulations
    
  shuffled_distribution = get_shuffled_binomial_distribution(measured_permutations, ...
    response_profiles, normalize);
  
  d_shuffled = sqrt(sum((ideal_distribution - shuffled_distribution).^2));
  
  plot(d_shuffled, get_counter(), 'k.');
  
  if d_measured > d_shuffled
    
    n_measured_further_away_than_shuffled = n_measured_further_away_than_shuffled + 1;
    
  else
    
    n_measured_closer_than_shuffled = n_measured_closer_than_shuffled + 1;
    
  end
  
end

sc_print.print(neuron.file_tag, n_measured_closer_than_shuffled / nbr_of_simulations);

end