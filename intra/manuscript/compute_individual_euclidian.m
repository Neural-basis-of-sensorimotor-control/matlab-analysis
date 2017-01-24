function euclidean_distances = compute_individual_euclidian(varargin)

titlestr = 'Avg distance btwn indiviual stims, intra-neuron val subtr';

[neurons, stims_str, ~, shuffle, all_responses] = ...
  init_intra_neurons(varargin{:});

nbr_of_dims = length(stims_str);%2*length(stims_str);%length(stims_str);%2*length(stims_str);
get_indx_fcn = @(x) x;%@(x) 2*x+[0; -1];%@(x) x;%@(x) 2*x+[0; -1];
get_response_fcn = @(stim, indx) stim.latency(indx);%@(stim, indx) [stim.height(indx); stim.latency(indx)];
%get_normalization_fcn = @(signal, electrode_ind) signal.userdata.single_pulse_height(electrode_ind);%@(signal, electrode_ind) 1;%
% get_normalization_fcn = @(signal, electrode_ind) ...
%   [signal.userdata.single_pulse_height(electrode_ind); ...
%   signal.userdata.single_pulse_latency(electrode_ind)];
%get_normalization_fcn = @(signal, electrode_ind) [1; 1];
get_normalization_fcn = @(signal, electrode_ind) signal.userdata.single_pulse_latency(electrode_ind);

[amplitude_values, neuron_tags] = generate_individual_response_matrix(...
  neurons, stims_str, nbr_of_dims, get_indx_fcn, get_response_fcn, ...
  get_normalization_fcn, 'all_responses', all_responses);

if shuffle
  is_nnz = find(amplitude_values);
  new_order = randperm(length(is_nnz));
  amplitude_values(is_nnz) = amplitude_values(is_nnz(new_order));
  titlestr = [titlestr ' - shuffled'];
end


%% Compute euclidean

euclidean_distances = nan(length(neurons));

for i=1:length(neurons)
  fprintf('compute euclidean: %d (%d)\n', i, length(neurons));
  
  tag1 = get_item({neurons.file_tag}, i);
  indx1 = find(cellfun(@(x) strcmp(x, tag1), neuron_tags));
  
  for j=1:length(neurons)
    tag2 = get_item({neurons.file_tag}, j);
    indx2 = find(cellfun(@(x) strcmp(x, tag2), neuron_tags));
    
    tmp_distance = nan(length(indx1), length(indx2));
    
    for k=1:length(indx1)
      for m=1:length(indx2)
        tmp_distance(k,m) = sqrt(sum((amplitude_values(:,indx1(k)) - amplitude_values(:,indx2(m))).^2));
      end
    end
    
    mean_distance = mean(tmp_distance(:));
    
    if i==j
      mean_distance = mean_distance * length(indx1)/(length(indx1)-1);
    end
    
    euclidean_distances(i,j) = mean_distance;
  end
end

%%

for i=1:size(euclidean_distances,1)
  euclidean_distances(:,i) = euclidean_distances(:,i) - euclidean_distances(i,i);
end

cla reset
fill_matrix(euclidean_distances)
axis square
set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
  'XTickLabelRotation', 270, ...
  'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_tag});

title(titlestr);
