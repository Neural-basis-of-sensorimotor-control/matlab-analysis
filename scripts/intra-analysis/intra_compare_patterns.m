function intra_compare_patterns
%flat fa - 1.0 sa
%'flat fa#V3#2', 'flat fa#V3#4', 'flat fa#V3#5'
%'1.0 sa#V3#2', '1.0 sa#V3#4', '1.0 sa#V3#5'

clear
reset_fig_indx()

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

load intra_data.mat
str_stims = {'flat fa#V3#2', 'flat fa#V3#4', 'flat fa#V3#5', '1.0 sa#V3#2', '1.0 sa#V3#4', '1.0 sa#V3#5'};

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  v = signal.get_v(true, true, true, true);
    
  for ij=1:4
    
    if ij ~= 3
      continue
    end
    
    incr_fig_indx();
    clf reset
    
    h1 = subplot(3, 1, 1);
    title(neuron.file_tag)
    
    artstim.plot_patterns(h1, {'flat fa' '1.0 sa'});
    
    h2 = subplot(3, 1, 2);
    title('V3 (manual amplitudes)')
    hold on
    grid on
    
    h3 = subplot(3, 1, 3);
    hold on
    grid on
    title('Average IC signal')
    
    indx2 = cellfun(@(x) strcmp(x, ['V' num2str(ij)]), intra_patterns.types);
        
    for j=1:length(str_first_stims)
      
      str_pattern = get_pattern(str_first_stims{j});
      
      switch str_pattern
        
        case {'flat fa' '1.0 sa'}
        otherwise
          continue
      end
      
      first_amplitude = signal.amplitudes.get('tag', str_first_stims{j});
      first_amplitude_indx = cellfun(@(x) strcmp(x, first_amplitude.tag), ...
        {intra_patterns.stim_electrodes.tag});
      first_amplitude_offset = ...
        intra_patterns.stim_electrodes(first_amplitude_indx).time;
      
      indx3 = cellfun(@(x) strcmp(x, str_pattern), intra_patterns.names);
      
      indx = indx1 & indx2 & indx3;
      
      tmp_str_stims = {intra_patterns.stim_electrodes(indx).tag};
      heights   = cell(size(tmp_str_stims));
      times     = nan(size(tmp_str_stims));
      n_indx    = find(indx);
      
      for k=1:length(tmp_str_stims)
               
        amplitude  = signal.amplitudes.get('tag', tmp_str_stims{k});
        heights(k) = {amplitude.height};
        times(k)   = intra_patterns.stim_electrodes(n_indx(k)).time - first_amplitude_offset;
        
      end
      
      axes(h2);
      mean_manual = nan(size(heights));
      
      for k=1:length(heights)
        
        plot(times(k)*ones(size(heights{k})), heights{k}, 'LineStyle', 'none', ...
          'Marker', '+', 'Tag', str_pattern);
        mean_manual(k) = mean(heights{k});
        
      end
      
      axes(h2)
      plot(times, mean_manual, 'LineStyle', '-', 'Marker', 'o', ...
        'Tag', str_pattern, ...
        'LineWidth', 2);
      
      [sweeps, sweeptimes] = sc_get_sweeps(v, 0, first_amplitude.stimtimes, -.1, .5, signal.dt);
      
      [~, ind_zero] = min(abs(sweeptimes));
      
      for kk=1:size(sweeps, 2)
        
        sweeps(:, kk) = sweeps(:, kk) - sweeps(ind_zero, kk);
        
      end
      
      msweeps = mean(sweeps, 2);
      
      axes(h3); %#ok<*LAXES>
      
      plot(sweeptimes, msweeps, 'LineStyle', '-', 'Marker', 'none', ...
        'LineWidth', 2, 'Tag', str_pattern);
      
    end
    
    linkaxes([h1 h2 h3], 'x');
    add_legend(gcf, true, false)
    
  end
  
end


