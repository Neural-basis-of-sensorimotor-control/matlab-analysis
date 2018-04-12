function intra_check_epsp_diff(neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.tags.INTRA);
sc_debug.set_mode(true);

nbr_of_electrodes = 4;
str_stims         = get_intra_motifs();
neurons           = intra_get_neurons();

if nargin
  neurons = neurons(neuron_indx);
end

[~, indx] = get_electrode(str_stims);
[~, indx] = sort(indx);
str_stims = str_stims(indx);

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  incr_fig_indx();
  clf
  subplot(4, 4, [1 2 5 6 9 10 13 14])
  hold on
  
  signal = sc_load_signal(neurons(i));
  
  enc_heights = cell(nbr_of_electrodes, 1);
  max_height = -inf;
  
  for j=1:length(str_stims)
    
    amplitude     = signal.amplitudes.get('tag', str_stims{j});
    heights       = amplitude.height;
    heights       = heights(heights>0);
    max_height    = max(max_height, max(heights));
    
    [~, electrode_indx] = get_electrode(amplitude);
    enc_heights(electrode_indx) = {concat_list(enc_heights{electrode_indx}, heights)};
    plot(electrode_indx*ones(size(heights)), heights, 'k+', 'Tag', str_stims{j});
    
  end

  set(gca, 'XTick', 1:nbr_of_electrodes, ...
    'XTickLabel', ...
    arrayfun(@(x) sprintf('V%d', x), 1:nbr_of_electrodes, 'UniformOutput', false), ...
    'XTickLabelRotation', 270);
  ylabel('EPSP amplitude height [mV]')
  grid on
  title(neurons(i).file_tag)
  
  edges = 0:1:max_height;
  
  axis tight
  xlim([0 (nbr_of_electrodes+1)])
  add_legend(gcf, true, false, 'Location', 'EastOutside');
  
  h1 = subplot(4, 4, 3:4);
  histogram(enc_heights{1}, edges)
  title('V1')
  xlabel('EPSP amplitude height [mV]')
  ylabel('Number of occurences')
  
  h2 = subplot(4, 4, 4+(3:4));
  histogram(enc_heights{2}, edges)
  title('V2')
  xlabel('EPSP amplitude height [mV]')
  ylabel('Number of occurences')
  
  h3 = subplot(4, 4, 8+(3:4));
  histogram(enc_heights{3}, edges)
  title('V3')
  xlabel('EPSP amplitude height [mV]')
  ylabel('Number of occurences')
  
  h4 = subplot(4, 4, 12+(3:4));
  histogram(enc_heights{4}, edges)
  title('V4')
  xlabel('EPSP amplitude height [mV]')
  ylabel('Number of occurences')
  
  linkaxes([h1 h2 h3 h4]);
  
end

