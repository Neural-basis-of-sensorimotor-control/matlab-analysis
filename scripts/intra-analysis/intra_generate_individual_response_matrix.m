function [amplitude_values, neuron_tags] = ...
  intra_generate_individual_response_matrix(neurons, stims_str, nbr_of_dims, ...
  get_indx_fcn, get_response_fcn, get_normalization_fcn, height_limit, ...
  min_epsp_nbr, varargin)

all_responses = false;

for i=1:2:length(varargin)
  switch varargin{i}
    case 'all_responses'
      all_responses = varargin{i+1};
    otherwise
      error('Unknown option: %s', varargin{i+1});
  end
end

amplitude_values = nan(nbr_of_dims, 1000);
neuron_tags = cell(1000, 1);

count = 0;

for i2=1:length(neurons)
  
  fprintf('%d (%d)\n', i2, length(neurons))
  
  neuron = neurons(i2);
  
  signal = sc_load_signal(neuron);
  stims = get_items(signal.amplitudes.list, 'tag', stims_str);
  
  if all_responses
    is_response = true(size(stims_str));
  else
    is_response = intra_generate_response_matrix(signal, stims_str, height_limit, ...
      min_epsp_nbr);
  end
  %
  %   min_nbr_of_stims = min(cell2mat(get_values(stims(is_response), ...
  %     @(x) nnz(x.valid_data))))
  
  min_nbr_of_stims = 10;
  
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

end

