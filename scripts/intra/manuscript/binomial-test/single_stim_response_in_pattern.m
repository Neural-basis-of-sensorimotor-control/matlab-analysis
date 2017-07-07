function single_stim_response_in_pattern(neurons, response_min, response_max, ...
  plot_only_final_figures)

%% Parameters
nbr_of_simulations = 1e4;
normalize_distributions = true;

stims_str = get_intra_motifs();

stim_pulses = select_stim_pulses(stims_str);

[dist_neuron_to_avg_response,                            ...
  ~,                                                     ...
  dist_shuffled_to_avg_response,                         ...
  dist_shuffled_to_avg_response_several_simulations_1,   ...
  dist_shuffled_to_avg_response_several_simulations_2] = ...
  compute_eucl_dist(neurons, stim_pulses, stims_str, response_min, response_max, ...
  nbr_of_simulations, normalize_distributions);

stim_pulses_labels = ...
  arrayfun(@(x) sprintf('%s - %s - %d', x.pattern, x.electrode, x.electrode_count), ...
  stim_pulses, 'UniformOutput', false);

if ~plot_only_final_figures
  for i=1:length(neurons)
    incr_fig_indx();
    
    bar([dist_neuron_to_avg_response(:,i) dist_shuffled_to_avg_response(:,i) ...
      dist_shuffled_to_avg_response_several_simulations_1(:,i) ...
      dist_shuffled_to_avg_response_several_simulations_2(:,i)])
    
    legend('Measurement to avg response', 'Shuffled to avg response', ...
      sprintf('Shuffled %d times', nbr_of_simulations),               ...
      sprintf('Shuffled %d times', nbr_of_simulations));
    
    set(gca, 'XTick', 1:length(stim_pulses), ...
      'XTickLabel', stim_pulses_labels, ...
      'XTickLabelRotation', 270);
    
    title(sprintf('%s, time window: %g - %g', neurons(i).file_tag, response_min, ...
      response_max));
  end
  
  for i=1:length(neurons)
    incr_fig_indx();
    
    hist([dist_neuron_to_avg_response(:,i) dist_shuffled_to_avg_response(:,i) ...
      dist_shuffled_to_avg_response_several_simulations_1(:,i) ...
      dist_shuffled_to_avg_response_several_simulations_2(:,i)]);
    
    legend('Measurement to avg response', 'Shuffled to avg response', ...
      sprintf('Shuffled %d times', nbr_of_simulations), ...
      sprintf('Shuffled %d times', nbr_of_simulations));
    
    title(sprintf('%s, time window: %g - %g s', neurons(i).file_tag, response_min, ...
      response_max));
  end
end

avg_response = nan(length(stim_pulses), length(neurons));
avg_response_repeated_simulations_1 = nan(length(stim_pulses), length(neurons));
avg_response_repeated_simulations_2 = nan(length(stim_pulses), length(neurons));

for i=1:length(neurons)
  avg_response(:,i) = log(dist_neuron_to_avg_response(:,i)./dist_shuffled_to_avg_response(:,i));
  avg_response_repeated_simulations_1(:,i) = log(dist_neuron_to_avg_response(:,i)./dist_shuffled_to_avg_response_several_simulations_1(:,i));
  avg_response_repeated_simulations_2(:,i) = log(dist_neuron_to_avg_response(:,i)./dist_shuffled_to_avg_response_several_simulations_2(:,i));
end


%%

incr_fig_indx();
hold(gca, 'on');
set(gca);

linestyle = ':';
markersize = 12;

for i=1:length(neurons)
  dummy_y = 1:length(stim_pulses);
  
  plot(avg_response_repeated_simulations_1(:,i), dummy_y, ...
    'LineStyle', linestyle, 'Tag', neurons(i).file_tag);
  
  plot(avg_response_repeated_simulations_1(:,i), dummy_y, ...
    'Marker', '+', 'MarkerSize', markersize, ...
    'LineStyle', 'none', 'Tag', neurons(i).file_tag);
  
end

save temp_backup_1

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

if ~plot_only_final_figures
  
  incr_fig_indx();
  hold(gca, 'on');
  set(gca, 'Color', 'k', 'GridColor', 'w');
  
  linestyle = ':';
  markersize = 12;
  
  for i=1:length(neurons)
    dummy_y = 1:length(stim_pulses);
    plot(avg_response_repeated_simulations_2(:,i), dummy_y, 'LineStyle', ...
      linestyle, 'Tag', neurons(i).file_tag);
    plot(avg_response_repeated_simulations_2(:,i), dummy_y, 'Marker', '+', ...
      'MarkerSize', markersize, 'LineStyle', 'none', 'Tag', ...
      neurons(i).file_tag);
  end
  plot(mean(avg_response_repeated_simulations_2, 2), 1:length(stim_pulses), ...
    'Tag', 'Mean', 'LineWidth', 2)
  
  axis_wide(gca, 'y')
  add_legend(gca, true, true, 'TextColor', 'r')
  grid on
  title(sprintf('Avg response (Eq. 4), time window: %g - %g', ...
    response_min, response_max));
  
  set(gca, 'YTick', 1:length(stim_pulses), 'YTickLabel', stim_pulses_labels);
  ylabel('Pattern - Electrode - Nbr of electrodes');
  xlabel('Value of eq 4');
end

%%

p = [.05 .01 .001 .0001];
alpha = tinv(1-p, length(neurons)-1);
success = false(length(stim_pulses_labels), length(alpha));

mean_avg_response = mean(avg_response_repeated_simulations_1,2);
std_avg_response = std(avg_response_repeated_simulations_1,1,2);

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

mean_avg_response = mean(avg_response_repeated_simulations_2,2);
std_avg_response = std(avg_response_repeated_simulations_2,1,2);

for i=1:size(success,2)
  success(:,i) = mean_avg_response - alpha(i)*std_avg_response/sqrt(length(neurons)) > 0;
end

if ~plot_only_final_figures
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

if ~plot_only_final_figures
  incr_fig_indx
  plot_amplitude_latencies(neurons, all_selected_stims);
end

end



%% Select only electrodes with > 1 selected pulse
function stim_pulses = select_stim_pulses(stims_str)

patterns_str = get_values(stims_str, @get_pattern);
unique_patterns_str = unique(patterns_str);

stim_pulses = [];

for i=1:length(unique_patterns_str)
  tmp_pattern = unique_patterns_str{i};
  
  tmp_stims_str = get_items(stims_str, @get_pattern, tmp_pattern);
  
  [tmp_electrodes, counts] = count_items_in_list(tmp_stims_str, @get_electrode);
  tmp_ind = counts>1;
  tmp_electrodes = tmp_electrodes(tmp_ind);
  tmp_counts = counts(tmp_ind);
  
  for j=1:length(tmp_electrodes)
    
    stim_pulses = add_to_list(stim_pulses, struct('pattern', tmp_pattern, ...
      'electrode', tmp_electrodes{j}, 'electrode_count', tmp_counts(j)));
    
  end
  
end

% Sort stim pulses
[~, ind1] = sort({stim_pulses.pattern});
stim_pulses = stim_pulses(ind1);

[~, ind1] = sort({stim_pulses.electrode});
stim_pulses = stim_pulses(ind1);

[~, ind1] = sort(cell2mat({stim_pulses.electrode_count}));
stim_pulses = stim_pulses(ind1);

end


%% Make a summary for each pattern how many neurons for which the distance 
% from recorded data to null hypothesis is larger than shuffled data to 
% null hypothesis
function [dist_neuron_to_avg_response, dist_neuron_to_shuffled, ...
  dist_shuffled_to_avg_response, ...
  dist_shuffled_to_avg_response_several_simulations_1, ...
  dist_shuffled_to_avg_response_several_simulations_2] = ...
  compute_eucl_dist(neurons, stim_pulses, stims_str, response_min, response_max, ...
  nbr_of_simulations, normalize_distributions)

dim = [length(stim_pulses), length(neurons)];

dist_neuron_to_avg_response   = nan(dim);
dist_neuron_to_shuffled       = nan(dim);
dist_shuffled_to_avg_response = nan(dim);
dist_shuffled_to_avg_response_several_simulations_1 = nan(dim);
dist_shuffled_to_avg_response_several_simulations_2 = nan(dim);


for i=1:length(stim_pulses)
  
  fprintf('%d out of %d\n', i, length(stim_pulses));
  
  pattern_str = stim_pulses(i).pattern;
  electrode_str = stim_pulses(i).electrode;
  tmp_stims = get_items(stims_str, @get_pattern, pattern_str);
  tmp_stims = get_items(tmp_stims, @get_electrode, electrode_str);
  
  for j=1:length(neurons)
    
    fprintf('\t%d out of %d\n', j, length(neurons));
    
    neuron = neurons(j);
    
    [neuron_distribution, stat_distribution_avg_response, shuffled_distribution, ...
      ~, ~, response_profiles] ...
      = compute_binomial_distribution(neuron, tmp_stims, response_min, ...
      response_max, normalize_distributions);
    
    dist_neuron_to_avg_response(i,j)   = ...
      sqrt(sum( (neuron_distribution-stat_distribution_avg_response).^2 ));
    dist_neuron_to_shuffled(i,j)       = ...
      sqrt(sum( (neuron_distribution-shuffled_distribution).^2 ));
    dist_shuffled_to_avg_response(i,j) = ...
      sqrt(sum( (shuffled_distribution-stat_distribution_avg_response).^2 ));
    
    binomial_permutations = get_binomial_permutations(length(tmp_stims));
    binomial_permutations = logical(binomial_permutations);
    
    tmp_dist_shuffled_to_avg = 0;
    
    for k=1:nbr_of_simulations
    
      tmp_shuffled_distribution = get_shuffled_binomial_distribution(...
        binomial_permutations, response_profiles, normalize_distributions);
      
      tmp_dist_shuffled_to_avg = tmp_dist_shuffled_to_avg + ...
        sqrt(sum( (tmp_shuffled_distribution-stat_distribution_avg_response).^2 ));
    
    end
    
    dist_shuffled_to_avg_response_several_simulations_1(i,j) = tmp_dist_shuffled_to_avg/nbr_of_simulations;
    
    tmp_dist_shuffled_to_avg = 0;
    
    for k=1:nbr_of_simulations
    
      tmp_shuffled_distribution = get_shuffled_binomial_distribution(...
        binomial_permutations, response_profiles, normalize_distributions);
      
      tmp_dist_shuffled_to_avg = tmp_dist_shuffled_to_avg + ...
        sqrt(sum( (tmp_shuffled_distribution-stat_distribution_avg_response).^2 ));
    
    end
    
    dist_shuffled_to_avg_response_several_simulations_2(i,j) = tmp_dist_shuffled_to_avg/nbr_of_simulations;
  
  end
  
end

end