%@todo: Compensate for different stimulation electrodes!
clc
clear
sc_clf_all('reset')

%% Parameters

exclude_neurons = {};%{'CANR0001'};
response_min = 4e-3;
response_max = 22e-3;
neurons = get_intra_neurons();
neurons = rm_from_list(neurons, 'file_tag', exclude_neurons);

stims_str = get_intra_motifs();

load intra_data.mat
stim_params = get_items(intra_patterns.stim_electrodes, 'tag', stims_str);
indx = cell2mat({stim_params.time_to_subsequent_stim}) > response_max - response_min;
stims_str = stims_str(indx);

nbr_of_sweeps = nan(size(neurons));

for i=1:length(nbr_of_sweeps)
  signal = sc_load_signal(neurons(i));
  nbr_of_sweeps(i) = get_nbr_of_sweeps(get_items(signal.amplitudes.list, 'tag', stims_str));
end

neurons = neurons(nbr_of_sweeps == 100);

% for i=1:4
%   stims_str = concat_list(stims_str, get_single_amplitudes(sprintf('%d', i)));
% end
%
patterns_str = get_values(stims_str, @get_pattern);
unique_patterns_str = unique(patterns_str);
%
% single_pulse_prefix = '1p electrode ';
%
% unique_patterns_str = [unique_patterns_str(~startsWith(unique_patterns_str, single_pulse_prefix)); ...
%   unique_patterns_str(startsWith(unique_patterns_str, single_pulse_prefix))];


nbr_of_stim_occurences = [];

for i=length(unique_patterns_str):-1:1
  tmp_stims_str = get_items(stims_str, @get_pattern, unique_patterns_str{i});
  [~, counts] = count_items_in_list(tmp_stims_str, @get_electrode);
  
  if isempty(counts) || counts(1) <= 1
    unique_patterns_str = rm_from_list(unique_patterns_str, i);
  else
    nbr_of_stim_occurences = add_to_list(nbr_of_stim_occurences, counts(1));
  end
end
nbr_of_stim_occurences = nbr_of_stim_occurences(length(nbr_of_stim_occurences):-1:1);

scaling_dim = 2;

% %% Generate binomial distribution for each neuron
%
% for i=1:length(neurons)
%   fprintf('%d out of %d\n', i, length(neurons));
%
%   neuron = neurons(i);
%
%   for j=1:length(unique_patterns_str)
%     incr_fig_indx();
%
%     pattern_str = unique_patterns_str{j};
%
%     [neuron_distribution, statistical_distribution_avg_response, ...
%       statistical_distribution_lsqfit, shuffled_distribution, ...
%       binomial_permutations, nbr_of_positives] = ...
%       compute_binomial_distribution(neuron, stims_str, pattern_str, ...
%       response_min, response_max, false);
%
%     plot_neuronal_binomial_distribution(binomial_permutations, nbr_of_positives, ...
%       [neuron.file_tag ': ' pattern_str], ...
%       {'Recorded data', 'Null hypothesis (avg response)', 'Null hypothesis (lsq fit)', 'Shuffled data'}, ...
%       neuron_distribution, statistical_distribution_avg_response, ...
%       statistical_distribution_lsqfit, shuffled_distribution);
%
%   end
%
% end

% %% Make PCA plot for a) all neurons together, and b) neuron vs each control (if relevant)
%
% for i=1:length(unique_patterns_str)
%   fprintf('%d out of %d\n', i, length(unique_patterns_str));
%
%   pattern_str = unique_patterns_str{i};
%
%   dim = [2^nbr_of_stim_occurences(i) length(neurons)];
%   neuron_distribution = nan(dim);
%   stat_distribution_avg_response = nan(dim);
%   stat_distribution_lsqfit = nan(dim);
%   shuffled_distribution = nan(dim);
%
%   for j=1:length(neurons)
%     fprintf('\t%d out of %d\n', j, length(neurons));
%
%     neuron = neurons(j);
%
%     [neuron_distribution(:,j), stat_distribution_avg_response(:,j), ...
%       stat_distribution_lsqfit(:,j), shuffled_distribution(:,j)] ...
%       = compute_binomial_distribution(neuron, stims_str, pattern_str, ...
%       response_min, response_max, true);
%   end
%
%   tags = repmat({neurons.file_tag}, 1, 4);
%   markers = [repmat({'+'}, 1, length(neurons)) repmat({'<'}, 1, length(neurons)) repmat({'>'}, 1, length(neurons)) repmat({'*'}, 1, length(neurons))];
%
%   d = pdist([neuron_distribution stat_distribution_avg_response stat_distribution_lsqfit shuffled_distribution]');
%   y1 = mdscale(d, scaling_dim);
%   y2 = cmdscale(d, scaling_dim);
%
%   incr_fig_indx();
%
%   subplot(121)
%   plot_mda(y1, tags, markers);
%   title([pattern_str ' (non-linear MDS)']);
%
%   subplot(122)
%   plot_mda(y2, tags, markers);
%   title([pattern_str ' (classical MDS)']);
%   add_legend(gcf, true);
%
% end


%% Make a summary for each pattern how many neurons for which the distance from recorded data to null hypothesis is larger than shuffled data to null hypothesis

dim = [length(unique_patterns_str), length(neurons)];

dist_neuron_to_avg_response   = nan(dim);
dist_neuron_to_lsqfit         = nan(dim);
dist_neuron_to_shuffled       = nan(dim);
dist_shuffled_to_avg_response = nan(dim);
dist_shuffled_to_lsqfit       = nan(dim);
dist_avg_response_to_lsqfit   = nan(dim);

for i=1:length(unique_patterns_str)
  fprintf('%d out of %d\n', i, length(unique_patterns_str));
  pattern_str = unique_patterns_str{i};
  
  for j=1:length(neurons)
    fprintf('\t%d out of %d\n', j, length(neurons));
    
    neuron = neurons(j);
    signal = sc_load_signal(neuron);
    
    tmp_stims_str = stims_str;
    
    for k=length(tmp_stims_str):-1:1
      if ~list_contains(signal.amplitudes.list, 'tag', tmp_stims_str{k})
        tmp_stims_str = rm_from_list(tmp_stims_str, k);
      end
    end
    
    
    [neuron_distribution, stat_distribution_avg_response, ...
      stat_distribution_lsqfit, shuffled_distribution] ...
      = compute_binomial_distribution(neuron, tmp_stims_str, pattern_str, ...
      response_min, response_max, true);
    
    dist_neuron_to_avg_response(i,j)   = sqrt(sum( (neuron_distribution-stat_distribution_avg_response).^2 ));
    dist_neuron_to_lsqfit(i,j)         = sqrt(sum( (neuron_distribution-stat_distribution_lsqfit).^2 ));
    dist_neuron_to_shuffled(i,j)       = sqrt(sum( (neuron_distribution-shuffled_distribution).^2 ));
    dist_shuffled_to_avg_response(i,j) = sqrt(sum( (shuffled_distribution-stat_distribution_avg_response).^2 ));
    dist_shuffled_to_lsqfit(i,j)       = sqrt(sum( (shuffled_distribution-stat_distribution_lsqfit).^2 ));
    dist_avg_response_to_lsqfit(i,j)  = sqrt(sum( (stat_distribution_avg_response-stat_distribution_lsqfit).^2 ));
  end
  
end

%%
global fig_indx

fig_indx = 0;

for i=1:length(neurons)
  incr_fig_indx();
  
  bar([dist_neuron_to_avg_response(:,i) dist_neuron_to_lsqfit(:,i) ...
    dist_shuffled_to_avg_response(:,i) dist_shuffled_to_lsqfit(:,i)])
  
  legend('Measurement to avg response', 'Measurement to lsq fit', ...
    'Shuffled to avg response', 'Shuffled to lsq fit');
  set(gca, 'XTick', 1:length(unique_patterns_str), 'XTickLabel', unique_patterns_str, ...
    'XTickLabelRotation', 270);
  title(neurons(i).file_tag)
end

for i=1:length(neurons)
  incr_fig_indx();
  
  hist([dist_neuron_to_avg_response(:,i) dist_neuron_to_lsqfit(:,i) ...
    dist_shuffled_to_avg_response(:,i) dist_shuffled_to_lsqfit(:,i)]);
  
  
  legend('Measurement to avg response', 'Measurement to lsq fit', ...
    'Shuffled to avg response', 'Shuffled to lsq fit');
  title(neurons(i).file_tag);
end

avg_response = nan(length(unique_patterns_str), length(neurons));
lsq_fit = nan(length(unique_patterns_str), length(neurons));

for i=1:length(neurons)
  incr_fig_indx();
  hold on
  
  dummy_y = 1:dim(1);
  linestyle = '-';
  markersize = 12;
  
  avg_response(:,i) = log(dist_neuron_to_avg_response(:,i)./dist_shuffled_to_avg_response(:,i));
  plot(avg_response(:,i), dummy_y, ...
    'LineStyle', linestyle, 'Marker', '+', 'MarkerSize', markersize, ...
    'Tag', 'Avg response');
  
  lsq_fit(:,i) = log(dist_neuron_to_lsqfit(:,i)./dist_shuffled_to_lsqfit(:,i));
  plot(lsq_fit, dummy_y, ...
    'LineStyle', linestyle, 'Marker', '+', 'MarkerSize', markersize, ...
    'Tag', 'Lsq fit');
  
  add_legend()
  
  title(neurons(i).file_tag);
  
  hold off
end

%%
p = .01;
alpha = tinv(1-p/2, length(neurons)-1);

mean_avg_response = mean(avg_response,2);
std_avg_response = std(avg_response,1,2);
mean_avg_response - alpha*std_avg_response/sqrt(length(neurons))

mean_lsq_fit = mean(lsq_fit,2);
std_lsq_fit = std(lsq_fit,1,2);
mean_lsq_fit - alpha*std_lsq_fit/sqrt(length(neurons))
% for i=1:length(neurons)
%   incr_fig_indx();
%
%   dummy_y = zeros([dim(1) 1]);
%
%   is_control = startsWith(unique_patterns_str, single_pulse_prefix);
%
%   hold on
%
%   plot(dist_neuron_to_avg_response(is_control,i), dummy_y(is_control), 'Marker', '+', 'LineStyle', 'None', 'Tag', 'Measurement to avg response (control)');
%   plot(dist_neuron_to_avg_response(~is_control,i), dummy_y(~is_control), 'Marker', 'x', 'LineStyle', 'None',  'Tag', 'Measurement to avg response');
%
%
%   plot(dist_neuron_to_lsqfit(is_control,i), dummy_y(is_control),  'Marker', '+', 'LineStyle', 'None', 'Tag', 'Measurement to lsq fit  (control)');
%   plot(dist_neuron_to_lsqfit(~is_control,i), dummy_y(~is_control), 'Marker', 'x', 'LineStyle', 'None',  'Tag', 'Measurement to lsq fit');
%
%   plot(dist_shuffled_to_avg_response(is_control,i), dummy_y(is_control), 'Marker', '>', 'LineStyle', 'None', 'Tag', 'Shuffled to avg response  (control)');
%   plot(dist_shuffled_to_avg_response(~is_control,i), dummy_y(~is_control), 'Marker', 'o', 'LineStyle', 'None', 'Tag', 'Shuffled to avg response');
%
%   plot(dist_shuffled_to_lsqfit(is_control,i), dummy_y(is_control), 'Marker', '>', 'LineStyle', 'None','Tag', 'Shuffled to lsq fit  (control)');
%     plot(dist_shuffled_to_lsqfit(~is_control,i), dummy_y(~is_control), 'Marker', 'o', 'LineStyle', 'None','Tag', 'Shuffled to lsq fit');
%
%
%   title(neurons(i).file_tag);
%   add_legend();
%
%   hold off
% end

% Compute P value for each neuron and pattern, with null hypothesis given
% by statistical model with constant response probability
