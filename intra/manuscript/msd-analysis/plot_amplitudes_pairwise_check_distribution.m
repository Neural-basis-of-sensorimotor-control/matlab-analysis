function plot_amplitudes_pairwise_check_distribution()


neuron = get_intra_neurons();

stim = get_intra_motifs();

pattern = get_values(stim, @get_pattern);

figs = [];

for i=1:length(neuron)
  
  f = incr_fig_indx();
  figs = add_to_list(figs, f);
  
  clf(f, 'reset');
  
  tmp_neuron = neuron(i);
  signal = sc_load_signal(tmp_neuron);
  
  plot_amplitudes_from_pattern(signal, pattern, stim);
  
end

h_plot = get_plots(figs);

incr_fig_indx();

clf('reset');
hold on

for i=1:length(h_plot)
  
  tmp_plot = h_plot(i);
  
  if ~strcmp(get(tmp_plot, 'Marker'), 'none')
    
    clone_plot(tmp_plot);
  
  end
end

add_diagonal();

xlabel('Tendency towards exclusive responses')
ylabel('Tendency towards mutual responses');

end


function plot_amplitudes_from_pattern(signal, pattern, stim)

unique_pattern = unique(pattern);

for i=1:length(unique_pattern)
  
  h = sc_square_subplot(length(unique_pattern), i);
  hold on
  
  tmp_pattern = unique_pattern{i};
  tmp_stim = stim(equals(pattern, tmp_pattern));

  plot_amplitudes_from_stim(signal, tmp_stim);

  title([signal.parent.tag ': ' tmp_pattern]);
  
  axis(h, 'tight');
  add_diagonal();
  xlabel('Tendency towards exclusive responses')
  ylabel('Tendency towards mutual responses');

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
    
    p_x = nnz(x)/length(x);
    p_y = nnz(y)/length(y);
    
    p_double_hit = p_x*p_y;
    real_double_hit = nnz(x~=0 & y~=0)/length(x);
    
    plot(p_double_hit, real_double_hit, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 14); 
  end
end

end