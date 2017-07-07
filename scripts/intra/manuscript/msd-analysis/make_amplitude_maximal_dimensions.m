function make_amplitude_maximal_dimensions(neurons, height_limit, min_epsp_nbr, ...
  plot_only_final_figures, varargin)

[neurons, stims_str, scaling_dim, shuffle] = ...
  init_intra_neurons(neurons, varargin{:});

nbr_of_dims = length(stims_str) * ...
  [1
  1
  1
  2
  3];

get_index_fcn = {
  @(x) x
  @(x) x
  @(x) x
  @(x) 2*x+ [0 -1]'
  @(x) 3*x+ [0 -1 -2]'};

get_response_fcn = {
  @(stim, indx) stim.get_amplitude_height(0, indx)
  @(stim, indx) stim.get_amplitude_width(0, indx)
  @(stim, indx) stim.get_amplitude_latency(0, indx)
  @(stim, indx) [stim.get_amplitude_height(0, indx); stim.get_amplitude_latency(0, indx)]
  @(stim, indx) [stim.get_amplitude_height(0, indx); stim.get_amplitude_latency(0, indx); stim.get_amplitude_width(0, indx)]};

get_normalization_fcn = {
  @(signal, electrode_ind) signal.userdata.single_pulse_height(electrode_ind)
  @(signal, electrode_ind) signal.userdata.single_pulse_width(electrode_ind)
  @(signal, electrode_ind) signal.userdata.single_pulse_latency(electrode_ind)
  @(signal, electrode_ind) [signal.userdata.single_pulse_height(electrode_ind); signal.userdata.single_pulse_latency(electrode_ind)]
  @(signal, electrode_ind) [signal.userdata.single_pulse_height(electrode_ind); signal.userdata.single_pulse_latency(electrode_ind); signal.userdata.single_pulse_width(electrode_ind)]};

titlestr = ...
  {'Height'
  'Width'
  'Latency'
  'Height + Latency'
  'Height + Latency + Time to peak'};


if plot_only_final_figures
  indx = [1 2 5];
else
  indx = 1:length(nbr_of_dims);
end

for i0=1:length(indx)
  
  i1 = indx(i0);
  
  fprintf('%s\n', titlestr{i1});
  make_amplitude_1(nbr_of_dims(i1), get_index_fcn{i1}, get_response_fcn{i1}, ...
    get_normalization_fcn{i1}, titlestr{i1});
  
end

  function make_amplitude_1(nbr_of_dims, get_indx_fcn, get_response_fcn, ...
      get_normalization_fcn, titlestr)
    
    [amplitude_values, neuron_tags] = ...
      generate_individual_response_matrix(neurons, stims_str, nbr_of_dims, ...
      get_indx_fcn, get_response_fcn, get_normalization_fcn, height_limit, ...
      min_epsp_nbr);
    
    if shuffle
      is_nnz = find(amplitude_values);
      new_order = randperm(length(is_nnz));
      amplitude_values(is_nnz) = amplitude_values(is_nnz(new_order));
      titlestr = [titlestr ' - shuffled'];
    end
    
    
    % Perform MDS
    d = pdist(amplitude_values');
    y = mdscale(d, scaling_dim);
    
    incr_fig_indx();
    clf reset
    
    h_subplot = [];
    
    h_subplot = add_to_list(h_subplot, subplot(221));
    
    plot_mda(y, neuron_tags);
    title([titlestr ' (Non-linear MDS)']);
    
    y = cmdscale(d, scaling_dim);
    
    h_subplot = add_to_list(h_subplot, subplot(222));
    
    plot_mda(y, neuron_tags);
    title([titlestr ' (Classical MDS)']);
       
    [~, score, ~, ~, explained] = pca(amplitude_values');
    
    h_subplot = add_to_list(h_subplot, subplot(223));
    hold on
    
    for i=1:size(score, 1)  
      plot(score(i,1), score(i,2), 'Marker', '.', 'MarkerSize', 12, ...
        'Tag', neuron_tags{i});
    end
    
    title('First two PCA coordinates')
    
    subplot(224);
    
    plot(cumsum(explained))
    xlabel('# of coordinates');
    ylabel('Percentage explained');
    ylim([0 110]);
    grid on
    
    add_legend(h_subplot, true);
    
  end

end