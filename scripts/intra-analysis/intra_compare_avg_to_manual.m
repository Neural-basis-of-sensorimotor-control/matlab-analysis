clear

sc_settings.set_current_settings_tag(sc_settings.tags.INTRA);
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

reset_fig_indx();

load intra_data.mat

str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron);
  
  v = signal.get_v(true, false, false, false);
  
  incr_fig_indx();
  clf
  
  for j=1:length(str_first_stims)
    
    sc_square_subplot(length(str_first_stims), j)
    hold on
    
    first_amplitude = signal.amplitudes.get('tag', str_first_stims{j});
    
    [sweeps, times] = sc_get_sweeps(v, 0, first_amplitude.stimtimes, -.1, .5, signal.dt);
    
    [~, ind_zero] = min(abs(times));
    
    for kk=1:size(sweeps, 2)
      
      sweeps(:, kk) = sweeps(:, kk) - sweeps(ind_zero, kk);
      
    end
    
    msweeps = mean(sweeps, 2);
        
    pattern = get_pattern(first_amplitude);
    
    str_pattern_stims = get_items(str_stims, @get_pattern, pattern);
    
    for k=1:length(str_pattern_stims)
      
      amplitude = signal.amplitudes.get('tag', str_pattern_stims{k});
      
      ind = cellfun(@(x) strcmp(str_pattern_stims{k}, x), {intra_patterns.stim_electrodes.tag});
      offset = intra_patterns.stim_electrodes(ind).time;
      [~, ind_offset] = min(abs(times - offset));
      
      x0 = offset + amplitude.latency;
      y0 = zeros(size(x0));
      
      x1 = x0 + amplitude.width;
      y1 = y0 + amplitude.height;
      
      ind = find(amplitude.valid_data);
      
      plot(offset, 0, '*', 'Tag', amplitude.tag)
      plot(x0, y0, 'o', 'Tag', amplitude.tag)
      plot(x1, y1, '+', 'Tag', amplitude.tag)
    
    end
    
    title([neuron.file_tag ': ' pattern])
    set(gca, 'Color', 'k');
    grid on
    add_legend(gca, true, true, 'Location', 'eastoutside', 'TextColor', 'w')
    
    xl = xlim;
    yl = ylim;
    
    h = plot(times, msweeps, 'LineWidth', 2);%, 'Tag', 'Avg sweep');
    uistack(h, 'bottom');
    
    xlim(xl);
    ylim(yl);
    
  end
  
end