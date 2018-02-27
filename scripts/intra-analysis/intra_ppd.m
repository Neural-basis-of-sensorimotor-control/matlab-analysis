clear
reset_fig_indx()

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

%Find interstim distances that are equal (for the same channel)
%plot_interstim_distances();
%plot_all_pulses();

ppd_amplitude = nan(length(neurons), 3);
ppd_time = nan(3, 1);

label_patterns = cell(3, 1);
plot_colors = cell(3, 1);

load intra_data.mat
str_stims = get_intra_motifs();

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

str_electrode = unique(intra_patterns.types);

str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

for i=1:length(neurons)
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  v = signal.get_v(true, true, true, true);
    
  for ij=1:4
    
    if ij ~= 3
      continue
    end
    
    incr_fig_indx();
    clf
    
    h1 = subplot(2, 2, 1);
    hold on
    title([neuron.file_tag ' ' 'V' num2str(ij)])
    grid on
    
    h2 = subplot(2, 2, 2);
    hold on
    grid on
    
    h3 = subplot(2, 2, 3:4);
    hold on
    grid on
    
    indx2 = cellfun(@(x) strcmp(x, ['V' num2str(ij)]), intra_patterns.types);
    
    barplot_indx = 0;
    
    for j=1:length(str_first_stims)
            
      str_pattern = get_pattern(str_first_stims{j});
      
      switch str_pattern
        
        case {'flat fa' 'flat sa' '2.0 fa'}
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
      
      axes(h1);
      mean_manual = nan(size(heights));
      
      for k=1:length(heights)
        
        h = plot(times(k)*ones(size(heights{k})), heights{k}, 'LineStyle', 'none', ...
          'Marker', '+', 'Tag', [str_pattern ' N = ' num2str(length(heights))]);
        mean_manual(k) = mean(heights{k});
        plot_colors(k) = {get(h, 'Color')}; 
        
      end
      
      barplot_indx = barplot_indx + 1;
      
      ppd_amplitude(i, barplot_indx) = mean_manual(2);%/mean_manual(1);
      ppd_time(barplot_indx) = times(2);
      label_patterns(barplot_indx) = {str_pattern};
      
      axes(h2)
      plot(times, mean_manual, 'LineStyle', '-', 'Marker', 'o', ...
        'Tag', [str_pattern ' N = ' num2str(length(heights))], ...
        'LineWidth', 2);
      
      [sweeps, sweeptimes] = sc_get_sweeps(v, 0, first_amplitude.stimtimes, -.1, .5, signal.dt);
      
      [~, ind_zero] = min(abs(sweeptimes));
      
      for kk=1:size(sweeps, 2)
        
        sweeps(:, kk) = sweeps(:, kk) - sweeps(ind_zero, kk);
        %plot(times, sweeps(:, kk))
        
      end
      
      msweeps = mean(sweeps, 2);
      
      axes(h3); %#ok<*LAXES>
      
      plot(sweeptimes, msweeps, 'LineStyle', '-', 'Marker', 'none', ...
        'LineWidth', 2, 'Tag', [str_pattern ' N = ' num2str(length(heights))]);
      
    end
    
    add_legend(gcf, true, false, 'Location', 'eastoutside')
  end
  
end

incr_fig_indx()
clf

hold on

bar(ppd_amplitude)
str_legend = cell(size(label_patterns));

for i=1:length(str_legend)
  str_legend(i) = {[label_patterns{i} ' (' num2str(round(1000*ppd_time(i))) ' ms)']};
end

legend(str_legend)
set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}); 
ylabel('amplitude second stimulation [mV]')


%Compare pulses from same channel at different places in pattern
function plot_all_pulses() %#ok<*DEFNU>

load intra_data.mat
str_stims    = get_intra_motifs();
str_patterns = get_patterns(1:8);

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

str_electrode = unique(intra_patterns.types);

incr_fig_indx();

clf
hold on

for i=1:length(neurons)
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  incr_fig_indx();
  clf
  
  for j=1:length(str_electrode)
    
    sc_square_subplot(4, j);
    hold on
    
    indx2        = cellfun(@(x) strcmp(x, str_electrode{j}), intra_patterns.types);
    
    for k=1:length(str_patterns)
      
      indx3 = cellfun(@(x) strcmp(x, str_patterns{k}), intra_patterns.names);
      
      indx = indx1 & indx2 & indx3;
      
      if nnz(indx)>=1
        
        str_stims = {intra_patterns.stim_electrodes(indx).tag};
        heights   = cell(size(str_stims));
        times     = nan(size(str_stims));
        n_indx    = find(indx);
        
        for m=1:length(str_stims)
          
          amplitude  = signal.amplitudes.get('tag', str_stims{m});
          heights(m) = {amplitude.height};
          times(m)   = intra_patterns.stim_electrodes(n_indx(m)).time;
          
        end
        
        for m=1:length(heights)
          
          plot(times(m)*ones(size(heights{m})), heights{m}, 'LineStyle', 'none', ...
            'Marker', '+', 'Tag', [str_patterns{k} ' N = ' num2str(length(heights))])
          
        end
        
      end
      
      title([neuron.file_tag ' ' str_electrode{j}])
      add_legend(gca, true, false, 'Location', 'eastoutside');
      
    end
    
  end
  
end

grid on
add_legend()

end

function plot_interstim_distances()

load intra_data.mat
str_stims    = get_intra_motifs();
str_patterns = get_patterns(1:8);

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

str_electrode = unique(intra_patterns.types);

incr_fig_indx();

clf
hold on

for i=1:length(str_electrode)
  
  indx2        = cellfun(@(x) strcmp(x, str_electrode{i}), intra_patterns.types);
  
  for j=1:length(str_patterns)
    
    indx3 = cellfun(@(x) strcmp(x, str_patterns{j}), intra_patterns.names);
    
    time_to_prev = cell2mat({intra_patterns.stim_electrodes(indx1 & indx2 & indx3).time_to_last_identical_stim});
    time_to_prev = sort(time_to_prev);
    
    plot(time_to_prev, ...
      (i-1)*8 + (j*ones(size(time_to_prev)) + .5*(1:length(time_to_prev))/length(time_to_prev))/8, ...
      'Marker', '+', 'LineStyle', 'none', 'Tag', str_patterns{j});
    
  end
  
end
grid on
add_legend()

end