function compute_euclidian
clc

is_responses = [];
response_values = [];
neurons = [];
stims = [];

% neurons = get_intra_neurons();
% stims = get_intra_motifs();
%
% is_responses = generate_response_matrix(neurons, stims);
% response_values = generate_response_value_matrix(neurons, stims, ...
%   @get_epsp_amplitude_single_pulse);
% response_values(~is_responses) = 0;
load response_values_tempdata.mat

all_shuffled_order = randperm(numel(response_values));
all_shuffled = nan(size(response_values));
count = 1;

for i=1:size(response_values,1)
  for j=1:size(response_values,2)
    all_shuffled(i,j) = response_values(all_shuffled_order(count));
    count = count+1;
  end
end

neurons_shuffled = nan(size(response_values));

for i=1:size(response_values,1)
  order = randperm(size(response_values,2));
  for j=1:length(order)
    neurons_shuffled(i,j) = response_values(i, order(j));
  end
end

stims_shuffled = nan(size(response_values));

for j=1:size(response_values,2)
  order = randperm(size(response_values,1));
  for i=1:length(order)
    stims_shuffled(i,j) = response_values(order(i), j);
  end
end

d_normal = compute_euclidian_distances(response_values);

make_figures(1, 'Euclidian distances amplitude height [mV]', d_normal);

d_all_shuffled = compute_euclidian_distances(all_shuffled);

make_figures(3, 'Euclidian distances amplitude height [mV], all shuffled', d_all_shuffled);

d_neurons_shuffled = compute_euclidian_distances(neurons_shuffled);

make_figures(5, 'Euclidian distances amplitude height [mV], neurons shuffled', d_neurons_shuffled);

d_stims_shuffled = compute_euclidian_distances(stims_shuffled);

make_figures(7, 'Euclidian distances amplitude height [mV], stims shuffled', d_stims_shuffled);


  function make_figures(fignbr, titlestr, d)
    
    fig1 = figure(fignbr);
    clf reset
    fill_matrix(d);
    colormap('gray')
    colorbar
    set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_str}, ...
      'XTickLabelRotation', 270, ...
      'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_str});
    axis tight
    title(titlestr);
    fig1.FileName = [titlestr '.png'];
    
    fig2 = figure(fignbr+1);
    clf reset
    fill_matrix(d);
    concat_colormaps(d, gca, 8, @gray, @(x) invert_colormap(@autumn, x));
    set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_str}, ...
      'XTickLabelRotation', 270, ...
      'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_str});
    axis tight
    title(titlestr);
    fig2.FileName = [titlestr '.png'];
    
  end

end


