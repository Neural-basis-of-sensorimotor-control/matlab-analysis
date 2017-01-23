function make_amplitude_maximal_dimensions(varargin)

clc

exclude_neurons = {};
scaling_dim = 2;
shuffle = false;

for i=1:2:length(varargin)
  
  switch varargin{i}
    case 'exclude_neurons'
      exclude_neurons = varargin{i+1};
    case 'scaling_dim'
      scaling_dim = varargin{i+1};
    case 'shuffle'
      shuffle = varargin{i+1};
    otherwise
      error('Illegal argument: %s', varargin{i});
  end
end

neurons = get_intra_neurons();
neurons = rm_from_list(neurons, 'file_tag', exclude_neurons);

stims_str = get_intra_motifs();

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
  figure(i1)
  clf reset
  
  fprintf('%s\n', titlestr{i1});
  make_amplitude_1(nbr_of_dims(i1), get_index_fcn{i1}, get_response_fcn{i1}, ...
    get_normalization_fcn{i1}, titlestr{i1});
end

  function make_amplitude_1(nbr_of_dims, get_indx_fcn, get_response_fcn, ...
      get_normalization_fcn, titlestr)
    
    amplitude_values = nan(nbr_of_dims, 1000);
    neuron_tags = cell(1000, 1);
    
    count = 0;
    
    for i2=1:length(neurons)
      
      fprintf('%d (%d)\n', i2, length(neurons))
      
      neuron = neurons(i2);
      
      signal = sc_load_signal(neuron);
      stims = get_items(signal.amplitudes, 'tag', stims_str);
      is_response = generate_response_matrix(signal, stims_str);
      
      min_nbr_of_stims = mean(cell2mat(get_values(stims(is_response), ...
        @(x) nnz(x.valid_data))));
      
      for j2=1:min_nbr_of_stims
        count = count + 1;
        neuron_tags(count) = {neuron.file_tag};
        
        for k=1:length(stims)
          
          ind1 = get_indx_fcn(k);
          
          if ~is_response(k)
            amplitude_values(ind1, count) = zeros(size(ind1));
          else
            stim = stims(k);
            
            if j2>length(stim.height)
              amplitude_values(ind1, count) = zeros(size(ind1));
            else
              [~, electrode_ind] = get_electrode(stim.tag);
              
              amplitude_values(ind1, count) = ...
                get_response_fcn(stim, j2) ./ ...
                get_normalization_fcn(signal, electrode_ind);
              
            end
          end
        end
      end
    end
    
    amplitude_values = amplitude_values(:, 1:count);
    neuron_tags = neuron_tags(1:count);
    
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