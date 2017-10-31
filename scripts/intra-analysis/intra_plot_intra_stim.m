function p_values = intra_plot_intra_stim(neurons, str_stims, height_limit, min_nbr_epsps, use_final_labels)

amplitude_heights = intra_get_values(str_stims, neurons, height_limit, min_nbr_epsps, @(x, varargin) x.get_amplitude_height(varargin{:}));
p_values          = [];

for i_neuron=1:length(neurons)
  
  p = zeros(length(str_stims));
  
  for i_stim1=1:length(str_stims)
    
    if ~isempty(amplitude_heights{i_stim1, i_neuron})
      
      for i_stim2=i_stim1+1:length(str_stims)
        
        if ~isempty(amplitude_heights{i_stim2, i_neuron})
          
          x1 = amplitude_heights{i_stim1, i_neuron};
          x2 = amplitude_heights{i_stim2, i_neuron};
          
          x1_tags = cellfun(@(~) 'a', cell(size(x1)) );
          x2_tags = cellfun(@(~) 'b', cell(size(x2)) );
          tags  = [x1_tags; x2_tags];
          m     = [x1; x2];
          
          tmp_p               = ranksum(x1, x2);
          p(i_stim1, i_stim2) = tmp_p;%anova1(m, tags, 'off');%
          p_values            = add_to_list(p_values, tmp_p);
          
        end
      end
    end
  end
  
  pos = any(p, 1)' | any(p, 2);
  
  p = p(pos, pos);
  
  tmp_stims = str_stims(pos);
  
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
  set(gca, 'XTick', 1:length(tmp_stims), 'XTickLabel', tmp_stims, 'YDir', 'reverse', ...
    'YTick', 1:length(tmp_stims), 'YTickLabel', tmp_stims, 'XTickLabelRotation', 270);
  title(neurons(i_neuron).file_tag, 'Interpreter', 'None');
  axis tight
  
  if use_final_labels
    
    set(gca, 'XTickLabel', intra_stim_tag_to_indx(get(gca, 'XTickLabel'), str_stims))
    set(gca, 'YTickLabel',  intra_stim_tag_to_indx(get(gca, 'YTickLabel'), str_stims))
    set(gca, 'YDir', 'reverse')
    set(gcf, 'Color', 'w')
    set(gca, 'Box', 'off')
    title(intra_file_tag_to_neuron_indx(i_neuron, neurons));
    
  end
  
end

end


