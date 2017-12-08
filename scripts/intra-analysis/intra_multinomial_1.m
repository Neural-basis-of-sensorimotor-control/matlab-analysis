function [simulated_distributions,  measured_distributions, ideal_distributions, stim_pulses] ...
  = intra_multinomial_1(neurons, response_min, response_max, ...
  plot_only_final_figures, nbr_of_simulations)

%% Parameters
normalize_distributions = true;
stims_str = get_intra_motifs();

stim_pulses = intra_get_multiple_stim_pulses(stims_str);

[dist_neuron_to_multinomial_response,                            ...
  ~,                                                     ...
  dist_shuffled_to_multinomial_response_single_repetition,                         ...
  dist_shuffled_to_multinomial_response_several_simulations_1,   ...
  simulated_distributions, ...
  measured_distributions,        ...
  ideal_distributions] = ...
  compute_eucl_dist(neurons, stim_pulses, stims_str, response_min, response_max, ...
  nbr_of_simulations, normalize_distributions);

stim_pulses_labels = ...
  arrayfun(@(x) sprintf('%s - %s - %d', x.pattern, x.electrode, x.electrode_count), ...
  stim_pulses, 'UniformOutput', false);

if ~plot_only_final_figures
  
  for i=1:length(neurons)
  
    incr_fig_indx();
    
    bar([dist_neuron_to_multinomial_response(:,i) dist_shuffled_to_multinomial_response_single_repetition(:,i) ...
      dist_shuffled_to_multinomial_response_several_simulations_1(:,i)])
    
    legend('Measurement to avg response', 'Shuffled to avg response', ...
      sprintf('Shuffled %d times', nbr_of_simulations));
    
    set(gca, 'XTick', 1:length(stim_pulses), ...
      'XTickLabel', stim_pulses_labels, ...
      'XTickLabelRotation', 270);
    
    title(sprintf('%s, time window: %g - %g', neurons(i).file_tag, response_min, ...
      response_max));
  
  end
  
  for i=1:length(neurons)
    
    incr_fig_indx();
    
    hist([dist_neuron_to_multinomial_response(:,i) dist_shuffled_to_multinomial_response_single_repetition(:,i) ...
      dist_shuffled_to_multinomial_response_several_simulations_1(:,i)]);
    
    legend('Measurement to avg response', 'Shuffled to avg response', ...
      sprintf('Shuffled %d times', nbr_of_simulations));
    
    title(sprintf('%s, time window: %g - %g s', neurons(i).file_tag, response_min, ...
      response_max));
  
  end  
end

avg_response                        = nan(length(stim_pulses), length(neurons));
avg_response_repeated_simulations_1 = nan(length(stim_pulses), length(neurons));

for i=1:length(neurons)
  
  avg_response(:,i)                        = ...
    log(dist_neuron_to_multinomial_response(:,i)./ ...
    dist_shuffled_to_multinomial_response_single_repetition(:,i));
  
  avg_response_repeated_simulations_1(:,i) = ...
    log(dist_neuron_to_multinomial_response(:,i)./ ...
    dist_shuffled_to_multinomial_response_several_simulations_1(:,i));

end


%%

incr_fig_indx();
hold(gca, 'on');
set(gca);

linestyle  = ':';
markersize = 12;

for i=1:length(neurons)
  
  dummy_y = 1:length(stim_pulses);
  
  plot(avg_response_repeated_simulations_1(:,i), dummy_y, ...
    'LineStyle', linestyle, 'Tag', neurons(i).file_tag);
  
  plot(avg_response_repeated_simulations_1(:,i), dummy_y, ...
    'Marker', '+', 'MarkerSize', markersize, ...
    'LineStyle', 'none', 'Tag', neurons(i).file_tag);
  
end

plot(mean(avg_response_repeated_simulations_1, 2), 1:length(stim_pulses), ...
  'Tag', 'Mean', 'LineWidth', 2)

axis_wide(gca, 'y')

add_legend(gca, true, false)

grid on

title(sprintf('Avg response (Eq. 4), time window: %g - %g', ...
  response_min, response_max));

set(gca, 'YTick', 1:length(stim_pulses), 'YTickLabel', stim_pulses_labels);
ylabel('Pattern - Electrode - Nbr of electrodes');
xlabel('Value of eq 4');

%%

p       = [.05 .01 .001 .0001];
alpha   = tinv(1-p, length(neurons)-1);
success = false(length(stim_pulses_labels), length(alpha));

mean_avg_response = mean(avg_response_repeated_simulations_1, 2);
std_avg_response = std(avg_response_repeated_simulations_1, 0, 2);

for i=1:size(success,2)
  success(:,i) = mean_avg_response - alpha(i)*std_avg_response/sqrt(length(neurons)) > 0;
end

fprintf('Pattern - electrode - nbr of pulses');

for i=1:length(p)
  fprintf('\tP = %g', p(i));
end
fprintf('\n');

for i=1:size(success,1)
  
  fprintf('%s', stim_pulses_labels{i});
  
  for j=1:size(success,2)
    
    if success(i,j)
      fprintf('\t''+');
    else
      fprintf('\t''-');
    end
    
  end
  
  fprintf('\n');
  
end


%%
all_selected_stims = {};

for i=1:length(stim_pulses)
  
  pattern_str = stim_pulses(i).pattern;
  electrode_str = stim_pulses(i).electrode;
  tmp_stims = get_items(stims_str, @get_pattern, pattern_str);
  tmp_stims = get_items(tmp_stims, @get_electrode, electrode_str);
  
  all_selected_stims = concat_list(all_selected_stims, tmp_stims);
  
end

save intra_statistical

end


%% Make a summary for each pattern how many neurons for which the distance 
% from recorded data to null hypothesis is larger than shuffled data to 
% null hypothesis
function [dist_neuron_to_multinomial_response, ...
  dist_neuron_to_shuffled, ...
  dist_shuffled_to_multinomial_response_single_repetion, ...
  dist_shuffled_to_multinomial_response_several_simulations, ...
  all_shuffled_distributions, ...
  all_neuron_distribution,        ...
  all_stat_distribution_multinomial_response] = ...
  compute_eucl_dist(neurons, stim_pulses, stims_str, response_min, response_max, ...
  nbr_of_simulations, normalize_distributions)

dim = [length(stim_pulses), length(neurons)];

dist_neuron_to_multinomial_response                       = nan(dim);
dist_neuron_to_shuffled                                   = nan(dim);
dist_shuffled_to_multinomial_response_single_repetion     = nan(dim);
dist_shuffled_to_multinomial_response_several_simulations = nan(dim);

all_shuffled_distributions                                = cell(dim);
all_neuron_distribution                                   = cell(dim);
all_stat_distribution_multinomial_response                = cell(dim);

for i_pattern=1:length(stim_pulses)
  
  sc_debug.print(mfilename, i_pattern, length(stim_pulses));
  
  pattern_str = stim_pulses(i_pattern).pattern;
  electrode_str = stim_pulses(i_pattern).electrode;
  tmp_stims = get_items(stims_str, @get_pattern, pattern_str);
  tmp_stims = get_items(tmp_stims, @get_electrode, electrode_str);
  
  for i_neuron=1:length(neurons)
        
    neuron = neurons(i_neuron);
    
    [neuron_distribution, stat_distribution_multinomial_response, shuffled_distribution, ...
      ~, ~, response_profiles] ...
      = compute_binomial_distribution(neuron, tmp_stims, response_min, ...
      response_max, normalize_distributions);
    
    dist_neuron_to_multinomial_response(i_pattern,i_neuron)   = ...
      sqrt(sum( (neuron_distribution-stat_distribution_multinomial_response).^2 ));
    dist_neuron_to_shuffled(i_pattern,i_neuron)       = ...
      sqrt(sum( (neuron_distribution-shuffled_distribution).^2 ));
    dist_shuffled_to_multinomial_response_single_repetion(i_pattern,i_neuron) = ...
      sqrt(sum( (shuffled_distribution-stat_distribution_multinomial_response).^2 ));
    
    binomial_permutations = get_binomial_permutations(length(tmp_stims));
    binomial_permutations = logical(binomial_permutations);
    
    tmp_dist_shuffled_to_avg       = 0;
    tmp_all_shuffled_distributions = nan(size(binomial_permutations, 1), nbr_of_simulations);
    
    for k=1:nbr_of_simulations
    
      tmp_shuffled_distribution        = get_shuffled_binomial_distribution(...
        binomial_permutations, response_profiles, normalize_distributions);
      
      tmp_all_shuffled_distributions(:, k) = tmp_shuffled_distribution;
      
      tmp_dist_shuffled_to_avg          = tmp_dist_shuffled_to_avg + ...
        sqrt(sum( (tmp_shuffled_distribution-stat_distribution_multinomial_response).^2 ));
    
    end
    
    all_shuffled_distributions                (i_pattern, i_neuron) = {tmp_all_shuffled_distributions};
    all_neuron_distribution                   (i_pattern, i_neuron) = {neuron_distribution};
    all_stat_distribution_multinomial_response(i_pattern, i_neuron) = {stat_distribution_multinomial_response};
    
    dist_shuffled_to_multinomial_response_several_simulations(i_pattern,i_neuron) = tmp_dist_shuffled_to_avg/nbr_of_simulations;
    

  end
  
end

end