function intra_compare_patterns(str_stims, electrode_index)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

neurons = intra_get_neurons();

load intra_data.mat

if ~nargin
  str_stims  = {'flat fa#V3#1', 'flat fa#V3#2', 'flat fa#V3#4', 'flat fa#V3#5', ...
    '1.0 sa#V3#1', '1.0 sa#V3#2', '1.0 sa#V3#4', '1.0 sa#V3#5'};
end

if nargin<2
  electrode_index = 3;
end

all_patterns = unique(get_values(str_stims, @get_pattern));

str_single = {'1p electrode 1#V1#1'
  '1p electrode 1#V1#2'
  '1p electrode 1#V1#3'
  '1p electrode 1#V1#4'
  '1p electrode 1#V1#5'
  '1p electrode 2#V2#1'
  '1p electrode 2#V2#2'
  '1p electrode 2#V2#3'
  '1p electrode 2#V2#4'
  '1p electrode 2#V2#5'
  '1p electrode 3#V3#1'
  '1p electrode 3#V3#2'
  '1p electrode 3#V3#3'
  '1p electrode 3#V3#4'
  '1p electrode 3#V3#5'
  '1p electrode 4#V4#1'
  '1p electrode 4#V4#2'
  '1p electrode 4#V4#3'
  '1p electrode 4#V4#4'
  '1p electrode 4#V4#5'};

pretrigger  = -.1;
posttrigger = .5;

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
    
    if ij ~= electrode_index
      continue
    end
    
    incr_fig_indx();
    clf reset
    
    block1 = [1:3 5:7 9:11 13:15];
    
    h1 = subplot(16, 4, block1);
    title(neuron.file_tag)
    ylabel('Stimulation electrode')
    
    artstim.plot_patterns(h1, all_patterns);
    
    h2 = subplot(16, 4, 20 + block1);
    title(['V' num2str(ij) ' (manual amplitudes)'])
    hold on
    grid on
    ylabel('EPSP amplitude')
    
    h3 = subplot(16, 4, 40 + block1);
    hold on
    grid on
    title('Average IC signal')
    ylabel('Avg IC signal (mV)')
    xlabel('Time (s)')
     
    block2 = 4:4:12;
    h4 = subplot(16, 4, block2);
    hold on
    grid on
    title('Single stim response (V1)')
    ylabel('Amplitude mV')
    
    h4(2) = subplot(16, 4, 16+block2);
    hold on
    grid on
    title('Single stim response (V2)')
    ylabel('Amplitude mV')
    
    h4(3) = subplot(16, 4, 32+block2);
    hold on
    grid on
    title('Single stim response (V3)')
    ylabel('Amplitude mV')
    
    h4(4) = subplot(16, 4, 48+block2);
    hold on
    grid on
    title('Single stim response (V4)')
    ylabel('Amplitude mV')
    xlabel('Time (s)')
    
    indx2 = cellfun(@(x) strcmp(x, ['V' num2str(ij)]), intra_patterns.types);
    
    for j=1:length(str_first_stims)
      
      str_pattern = get_pattern(str_first_stims{j});
      
      if ~any(cellfun(@(x) strcmp(x, str_pattern), all_patterns))
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
      heights       = cell(size(tmp_str_stims));
      times         = nan(size(tmp_str_stims));
      n_indx        = find(indx);
      valid_data    = cell(size(tmp_str_stims));
      
      for k=1:length(tmp_str_stims)
        
        amplitude     = signal.amplitudes.get('tag', tmp_str_stims{k});
        heights(k)    = {amplitude.height};
        times(k)      = intra_patterns.stim_electrodes(n_indx(k)).time - first_amplitude_offset;
        valid_data(k) = {amplitude.valid_data};
        
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
      
      [sweeps, sweeptimes] = sc_get_sweeps(v, 0, first_amplitude.stimtimes, ...
        pretrigger, posttrigger, signal.dt);
      
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
    xlim([pretrigger posttrigger])
    add_legend(gcf, true, false)
    
    for j=1:length(str_single)
      
      tmp_single_stim = str_single{j};
      
      amplitude = signal.amplitudes.get('tag', tmp_single_stim);
      
      if isempty(amplitude)
        continue
      end
      
      [~, subplot_indx] = get_electrode(amplitude);
      
      axes(h4(subplot_indx))
      
      [~, stim_indx] = get_stim_indx(amplitude);
      height = amplitude.height;
      
      plot(stim_indx*ones(size(height)), height, '+')
      axis tight
      
    end
    
    
    
    linkaxes(h4)
    
    xl = xlim;
    xlim([0 (xl(2)+1)]);
    yl = ylim;
    ylim([0 (yl(2))]);
    
    for j=1:length(h4)
      
      set(h4(j), 'XTick', 1:xl(2));
      
    end
    
    xlabel(h4(end), 'pulse nbr');
    
  end
  
end


