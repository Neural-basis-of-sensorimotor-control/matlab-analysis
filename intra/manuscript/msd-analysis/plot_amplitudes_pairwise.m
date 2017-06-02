function plot_amplitudes_pairwise()


neuron = get_intra_neurons();

stim = get_intra_motifs();

pattern = get_values(stim, @get_pattern);

for i=1:length(neuron)
  
  f = incr_fig_indx();
  clf(f, 'reset');
  
  tmp_neuron = neuron(i);
  signal = sc_load_signal(tmp_neuron);
  
  plot_amplitudes_from_pattern(signal, pattern, stim);
  linkaxes(get_axes(f));

end

end


function plot_amplitudes_from_pattern(signal, pattern, stim)

unique_pattern = unique(pattern);

for i=1:length(unique_pattern)
  
  h = sc_square_subplot(length(unique_pattern), i);
  hold on
  
  tmp_pattern = unique_pattern{i};
  tmp_stim = stim(equals(pattern, tmp_pattern));

  plot_amplitudes_from_stim(signal, tmp_stim);

  l = add_legend(h);
  set(l, 'Location', 'NorthEastOutside');
  title([signal.parent.tag ': ' tmp_pattern]);
  
  axis(h, 'tight');
end

end


function plot_amplitudes_from_stim(signal, stim)

amplitude = get_items(signal.amplitudes.list, 'tag', stim);

electrode = get_electrode(amplitude);

[unique_electrode, count] = count_items_in_list(electrode);

unique_electrode = unique_electrode(count > 1);

for i=1:length(unique_electrode)
  
  tmp_electrode = unique_electrode{i};
  tmp_amplitude = amplitude(equals(get_electrode(amplitude), tmp_electrode));
  
  plot_amplitudes(tmp_amplitude);
end

end


function plot_amplitudes(amplitude)

for i=1:length(amplitude)
  for j=i+1:length(amplitude)
    x = amplitude(i).data(:, 4) - amplitude(i).data(:, 2);
    y = amplitude(j).data(:, 4) - amplitude(j).data(:, 2);
    
    if length(x) ~= length(y)
      continue
    end
    
    x(isnan(x)) = 0;
    y(isnan(y)) = 0;
    
    plot(x, y, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 14, ...
      'Tag', [amplitude(i).tag ' - ' amplitude(j).tag]); 
  end
end

end