function [neurons, stims_str, scaling_dim, shuffle, all_responses] = ...
  intra_init_intra_neurons(neurons, varargin) 

scaling_dim = 2;
shuffle = false;
full_responses = false;
all_responses = false;

for i=1:2:length(varargin)
  
  switch varargin{i}
    case 'scaling_dim'
      scaling_dim = varargin{i+1};
    case 'shuffle'
      shuffle = varargin{i+1};
    case 'full_responses'
      full_responses = varargin{i+1};
    case 'all_responses'
      all_responses = varargin{i+1};
    otherwise
      error('Illegal argument: %s', varargin{i});
  end
end

if full_responses && all_responses
  error('full_responses and all_responses cannot both be true');
end

stims_str = get_intra_motifs();

if full_responses
  is_response = generate_response_matrix(neurons, stims_str);
  stims_str = stims_str(all(is_response,2));
end

end