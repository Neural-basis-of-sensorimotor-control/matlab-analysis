function all_p_values = intra_plot_inter_neuron ...
  (neurons, str_stims, height_limit, min_nbr_epsps, use_final_labels)

amplitude_heights = intra_get_values(str_stims, neurons, height_limit, min_nbr_epsps, @(x, varargin) x.get_amplitude_height(varargin{:}));
all_p_values      = [];

for i_stim=1:length(str_stims)
  
  tmp_str_stim = str_stims{i_stim};
  
  p = zeros(length(neurons));
  
  for i_neuron1=1:length(neurons)
    
    if ~isempty(amplitude_heights{i_stim, i_neuron1})
      
      for i_neuron2=i_neuron1+1:length(neurons)
        
        if ~isempty(amplitude_heights{i_stim, i_neuron2})
          
          tmp_p = ranksum(amplitude_heights{i_stim, i_neuron1}, ...
            amplitude_heights{i_stim, i_neuron2});
          
          p(i_neuron1, i_neuron2) = tmp_p;
          all_p_values            = add_to_list(all_p_values, tmp_p);
          
        end
      end
    end
  end
  
  incr_fig_indx
  clf
  fill_matrix(p);
  hold on
  
  [x, y] = find(p == 0);
  
  for i=1:length(x)
    
    x_ = x(i) + [-.5 -.5 .5 .5 -.5];
    y_ = y(i) + [-.5 .5 .5 -.5 -.5];
    fill(x_, y_, 'w');
    
  end
  
  try
    concat_colormaps(p, gca, .05, @autumn, @winter)
  catch
    warning('Could not make colormap');
    colormap('default');
  end
  
  colorbar
  set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
    'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_tag}, 'XTickLabelRotation', 270);
  title(tmp_str_stim, 'Interpreter', 'None');
  axis tight
  
  if use_final_labels
    
    set(gca, 'XTickLabel', intra_file_tag_to_neuron_indx(get(gca, 'XTickLabel'), neurons))
    set(gca, 'YTickLabel', intra_file_tag_to_neuron_indx(get(gca, 'YTickLabel'), neurons))
    set(gca, 'YDir', 'reverse')
    set(gcf, 'Color', 'w')
    set(gca, 'Box', 'off')
    title(intra_stim_tag_to_indx(tmp_str_stim, get_intra_motifs()));
    
  end
  
end

end