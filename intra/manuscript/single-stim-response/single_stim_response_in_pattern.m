clc
clear
sc_clf_all('reset')

global fig_indx

fig_indx = 0;
%% Parameters

response_min = 4e-3;
response_max = 22e-3;
neurons = get_intra_neurons();
stims_str = get_intra_motifs();
patterns_str = get_values(stims_str, @get_pattern);
unique_patterns_str = unique(patterns_str);
nbr_of_occurences = cellfun(@(x) nnz(cellfun(@(y) strcmp(x,y), patterns_str)), unique_patterns_str);
unique_patterns_str = unique_patterns_str(nbr_of_occurences > 1);
nbr_of_occurences = cellfun(@(x) nnz(cellfun(@(y) strcmp(x,y), patterns_str)), unique_patterns_str);
scaling_dim = 2;

% %% Generate binomial distribution for each neuron
% 
% for i=1:length(neurons)
%   fprintf('%d out of %d\n', i, length(neurons));
%   
%   neuron = neurons(i);
%   %   figure(i)
%   %   clf reset
%   
%   for j=1:length(unique_patterns_str)
%     incr_fig_indx();
%     
%     if fig_indx > 12
%       return
%     end
%     
%     pattern_str = unique_patterns_str{j};
%     %sc_square_subplot(length(unique_patterns_str), j)
%     
%     [neuron_distribution, statistical_distribution_avg_response, ...
%       statistical_distribution_lsqfit, shuffled_distribution, ...
%       binomial_permutations, nbr_of_positives] = ...
%       compute_binomial_distribution(neuron, stims_str, pattern_str, ...
%       response_min, response_max);
%     
%     plot_neuronal_binomial_distribution(binomial_permutations, nbr_of_positives, ...
%       [neuron.file_tag ': ' pattern_str], ...
%       {'Recorded data', 'Null hypothesis (avg response)', 'Null hypothesis (lsq fit)', 'Shuffled data'}, ...
%       neuron_distribution, statistical_distribution_avg_response, ...
%       statistical_distribution_lsqfit, shuffled_distribution);
%   end
% end

%% Make PCA plot for a) all neurons together, and b) neuron vs each control (if relevant)

for i=1:length(unique_patterns_str)
  fprintf('%d out of %d\n', i, length(unique_patterns_str));
  
  pattern_str = unique_patterns_str{i};
  
  dim = [2^nbr_of_occurences(i) length(neurons)];
  neuron_distribution = nan(dim);
  stat_distribution_avg_response = nan(dim);
  stat_distribution_lsqfit = nan(dim);
  shuffled_distribution = nan(dim);
  
  for j=1:length(neurons)
    neuron = neurons(j);
    
    [neuron_distribution(:,j), stat_distribution_avg_response(:,j), ...
      stat_distribution_lsqfit(:,j), shuffled_distribution(:,j)] ...
      = compute_binomial_distribution(neuron, stims_str, pattern_str, ...
      response_min, response_max);
  end
  
  tags = repmat({neurons.file_tag}, 1, 4);
  markers = repmat({'+', '<', '>', '*'}, 1, length(neurons));
  
  d = pdist([neuron_distribution stat_distribution_avg_response stat_distribution_lsqfit shuffled_distribution]');
  y1 = mdscale(d, scaling_dim);
  y2 = cmdscale(d, scaling_dim);
  
  incr_fig_indx();
  
  subplot(121)
  plot_mda(y1, tags, markers);
  title([pattern_str ' (non-linear MDS)']);
  
  subplot(122)
  plot_mda(y2, tags, markers);
  title([pattern_str ' (classical MDS)']);
  add_legend(gcf, true);
  
  return
end





% Compute P value for each neuron and pattern, with null hypothesis given
% by statistical model with constant response probability
