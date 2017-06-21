function intra_plot_amplitude_response(neurons, str_stims, min_height, min_n_epsp)

patterns        = get_values(str_stims, @get_pattern);
unique_patterns = unique(patterns);

for i=1:length(neurons)
  
  fprintf('%d out of %d\n', i, length(neurons))
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  i_subplot = 0;
  h_axes = [];

  for j=1:length(unique_patterns)
    
    tmp_pattern = unique_patterns{j};
    
    tmp_str_stims = str_stims(equals(patterns, tmp_pattern));
    
    tmp_amplitudes = get_items(signal.amplitudes.list, 'tag', tmp_str_stims);
    
    is_significant_response = arrayfun(...
      @(x) intra_is_significant_response(x, min_height, min_n_epsp), ...
      tmp_amplitudes);
    
    tmp_amplitudes = tmp_amplitudes(is_significant_response);
        
    for k=1:(length(tmp_amplitudes)-1)
      
      for m=k+1:length(tmp_amplitudes)
        
        
        responses = arrayfun(@get_all_heights, tmp_amplitudes([k m]), ...
          'UniformOutput', false);
        
        responses = cell2mat(responses');
        responses(isnan(responses)) = 0;
        
        responses(all(~responses, 2), :) = [];
        
        if mod(i_subplot, 24) == 0
          
          f = incr_fig_indx();
          clf(f, 'reset');
          
          i_subplot = 1;
          
        else
          
          i_subplot = i_subplot + 1;
          
        end
        
        h = subplot(4, 6, i_subplot);
        
        h_axes = add_to_list(h_axes, h);
        
        plot(h, responses(:,1), responses(:,2),  'MarkerSize', 12, ...
          'Marker', '.', 'LineStyle', 'none');
        
        axis(h, 'tight');
        
        xlabel(h, tmp_amplitudes(k).tag)
        ylabel(h, tmp_amplitudes(m).tag)
        
        title(h, neurons(i).file_tag);
        grid(h, 'on');
        
      end
      
    end
    
  end
  
  linkaxes(h_axes);
  
end

end

function w = get_all_heights(amplitude)

[~, w] = get_amplitude_height(amplitude, 0);

end