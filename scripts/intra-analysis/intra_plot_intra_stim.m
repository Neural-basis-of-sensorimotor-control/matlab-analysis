function all_p_values = intra_plot_intra_stim(neurons, str_stims, ...
  height_limit, min_nbr_epsp, modality, plot_on)

if ~exist('plot_on', 'var')
  plot_on = true;
end

switch modality
  
  case 'height'
    fcn = @(x, varargin) x.get_amplitude_height(varargin{:});
  case 'width'
    fcn = @(x, varargin) x.get_amplitude_width(varargin{:});
  case 'latency'
    fcn = @(x, varargin) x.get_amplitude_latency(varargin{:});
  otherwise
    error('Unknown command: %s', modality);
end

 
amplitude_values = intra_get_values(str_stims, neurons, height_limit, ...
  min_nbr_epsp, fcn);


all_p_values = [];

for i_neuron=1:length(neurons)
  
  p_ranksum        = zeros(length(str_stims));
  
  indx_multcmp     = 1:length(str_stims);
  indx_is_nonempty = true(size(indx_multcmp));
  
  tmp_neuron       = neurons(i_neuron);
  enc_values       = amplitude_values(:, i_neuron);
  
  for i_stim=1:length(enc_values)
    
    if isempty(enc_values{i_stim})
      
      indx_is_nonempty(i_stim) = false;
      continue;
      
    end
    
    for j_stim=i_stim+1:length(enc_values)
      
      if ~isempty(enc_values{j_stim})
        
        p_ranksum(i_stim, j_stim) = ranksum(enc_values{i_stim}, ...
          enc_values{j_stim});
        
      end
      
    end
    
  end
  
  p_ranksum = p_ranksum(indx_is_nonempty, :);
  p_ranksum = p_ranksum(:, indx_is_nonempty);
  
  all_p_values = concat_list(all_p_values, p_ranksum(p_ranksum ~= 0));
  
  if ~plot_on
    continue
  end
  
  incr_fig_indx();
  clf
  fill_matrix(p_ranksum);
  hold on
  
  [x, y] = find(p_ranksum == 0);
  
  for i_stim=1:length(x)
    
    x_ = x(i_stim) + [-.5 -.5 .5 .5 -.5];
    y_ = y(i_stim) + [-.5 .5 .5 -.5 -.5];
    
    fill(x_, y_, 'w');
    
  end
  
  try
    
    concat_colormaps(p_ranksum, gca, .05, @autumn, @winter)
  
  catch
    
    warning('Could not make colormap');
    colormap('default');
  
  end
  
  colorbar
  
  labels = str_stims(indx_is_nonempty);
  
  set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, 'YDir', ...
    'reverse', 'YTick', 1:length(labels), 'YTickLabel', labels, ...
    'XTickLabelRotation', 270);
  
  title(tmp_neuron.file_tag, 'Interpreter', 'None');
  axis tight
  
end

end