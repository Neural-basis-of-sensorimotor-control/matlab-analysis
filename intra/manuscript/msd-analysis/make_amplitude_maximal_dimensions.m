function make_amplitude_maximal_dimensions(varargin)


[neurons, stims_str, scaling_dim, shuffle] = ...
  init_intra_neurons(varargin{:});

nbr_of_dims = length(stims_str) * [1
  1
  1
  2];

get_index_fcn = {@(x) x
  @(x) x
  @(x) x
  @(x) 2*x+ [0 -1]'};

get_response_fcn = {@(stim, indx) stim.height(indx)
  @(stim, indx) stim.width(indx)
  @(stim, indx) stim.latency(indx)
  @(stim, indx) [stim.height(indx); stim.latency(indx)]};

get_normalization_fcn = ...
  {@(signal, electrode_ind) signal.userdata.single_pulse_height(electrode_ind)
  @(signal, electrode_ind) signal.userdata.single_pulse_width(electrode_ind)
  @(signal, electrode_ind) signal.userdata.single_pulse_latency(electrode_ind)
  @(signal, electrode_ind) [signal.userdata.single_pulse_height(electrode_ind); signal.userdata.single_pulse_latency(electrode_ind)]};

titlestr = {'Height'
  'Width'
  'Latency'
  'Height + Latency'
  };


for i1=1:length(nbr_of_dims)
  incr_fig_indx();
  clf reset
  
  fprintf('%s\n', titlestr{i1});
  make_amplitude_1(nbr_of_dims(i1), get_index_fcn{i1}, get_response_fcn{i1}, ...
    get_normalization_fcn{i1}, titlestr{i1});
end

  function make_amplitude_1(nbr_of_dims, get_indx_fcn, get_response_fcn, ...
      get_normalization_fcn, titlestr)
    
    [amplitude_values, neuron_tags] = ...
      generate_individual_response_matrix(neurons, stims_str, nbr_of_dims, ...
      get_indx_fcn, get_response_fcn, get_normalization_fcn);
    
    if shuffle
      is_nnz = find(amplitude_values);
      new_order = randperm(length(is_nnz));
      amplitude_values(is_nnz) = amplitude_values(is_nnz(new_order));
      titlestr = [titlestr ' - shuffled'];
    end
    
    
    % Perform MDS
    d = pdist(amplitude_values');
    y = mdscale(d, scaling_dim);
    
    subplot(121)
    plot_mda(y, neuron_tags);
    title([titlestr ' (Non-linear MDS)']);
    
    y = cmdscale(d, scaling_dim);
    
    subplot(122)
    plot_mda(y, neuron_tags);
    title([titlestr ' (Classical MDS)']);
    
    add_legend([subplot(121) subplot(122)], true);
    
  end
end