function plot_patterns(axes_handle, patterns)

load intra_data.mat
str_stims = get_intra_motifs();
str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

axes(axes_handle);
cla
hold on
grid on

for i=1:length(str_first_stims)
  
  str_pattern = get_pattern(str_first_stims{i});
  
  if ~any(cellfun(@(x) strcmp(x, str_pattern), patterns))
    continue
  end
  
  first_amplitude_indx = cellfun(@(x) strcmp(x, str_first_stims{i}), ...
    {intra_patterns.stim_electrodes.tag});
  first_amplitude_offset = ...
    intra_patterns.stim_electrodes(first_amplitude_indx).time;
  
  indx2 = cellfun(@(x) strcmp(x, str_pattern), intra_patterns.names);
  
  for j=1:4
    
    indx3 = cellfun(@(x) strcmp(x, ['V' num2str(j)]), intra_patterns.types);
    
    times1 = cell2mat({intra_patterns.stim_electrodes(~indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times1, j*ones(size(times1)), 'LineStyle', 'none', ...
      'Marker', 's', 'Tag', str_pattern);
    
    times2 = cell2mat({intra_patterns.stim_electrodes(indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times2, j*ones(size(times2)), 'LineStyle', 'none', ...
      'Marker', '*', 'Tag', str_pattern);
    
  end
  
end

ylim([0 5])

set(gca, 'YTick', 1:4, 'YTickLabel', {'V1', 'V2', 'V3', 'V4'})

end


% clear
% reset_fig_indx();
%
% plot_separate()
% plot_same_axes()

function plot_same_axes()

load intra_data.mat
str_stims = get_intra_motifs();
str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

fig = incr_fig_indx();
clf reset
hold on
grid on

dy = .6/length(str_first_stims);

for i=1:length(str_first_stims)
  
  if i~=7 && i~=4
    continue
  end
  
  str_pattern = get_pattern(str_first_stims{i});
  
  first_amplitude_indx = cellfun(@(x) strcmp(x, str_first_stims{i}), ...
    {intra_patterns.stim_electrodes.tag});
  first_amplitude_offset = ...
    intra_patterns.stim_electrodes(first_amplitude_indx).time;
  
  indx2 = cellfun(@(x) strcmp(x, str_pattern), intra_patterns.names);
  
  for j=1:4
    
    indx3 = cellfun(@(x) strcmp(x, ['V' num2str(j)]), intra_patterns.types);
    
    times1 = cell2mat({intra_patterns.stim_electrodes(~indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times1, j*ones(size(times1)) - .3 + i*dy, 'LineStyle', 'none', ...
      'Marker', 's', 'Tag', str_pattern);
    
    times2 = cell2mat({intra_patterns.stim_electrodes(indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times2, j*ones(size(times2)) - .3 + i*dy, 'LineStyle', 'none', ...
      'Marker', '*', 'Tag', str_pattern);
    
  end
  
end

ylim([0 5])

set(gca, 'XColor', 'w', 'YColor', 'w', 'Color', 'k', 'YTick', 1:4, ...
  'YTickLabel', {'V1', 'V2', 'V3', 'V4'})

add_legend(fig, true, true, 'Location', 'eastoutside', 'TextColor', 'w');
xl = xlim();
xlim([0 xl(2)]);
set(fig, 'Color', 'k');

end


function plot_separate()

load intra_data.mat
str_stims = get_intra_motifs();
str_first_stims = arrayfun(@(x) x.stim_electrodes(1).tag, intra_patterns.patterns, 'UniformOutput', false);

indx1 = false(size(intra_patterns.types));

for i=1:length(indx1)
  
  indx1(i) = any(cellfun(@(x) strcmp(x, intra_patterns.stim_electrodes(i).tag), ...
    str_stims));
  
end

fig = incr_fig_indx();
clf reset

for i=1:length(str_first_stims)
  
  str_pattern = get_pattern(str_first_stims{i});
  
  first_amplitude_indx = cellfun(@(x) strcmp(x, str_first_stims{i}), ...
    {intra_patterns.stim_electrodes.tag});
  first_amplitude_offset = ...
    intra_patterns.stim_electrodes(first_amplitude_indx).time;
  
  indx2 = cellfun(@(x) strcmp(x, str_pattern), intra_patterns.names);
  
  h = sc_square_subplot(length(str_first_stims), i);
  hold on
  title(str_pattern, 'Color', 'w')
  grid on
  
  for j=1:4
    
    indx3 = cellfun(@(x) strcmp(x, ['V' num2str(j)]), intra_patterns.types);
    
    times1 = cell2mat({intra_patterns.stim_electrodes(~indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times1, j*ones(size(times1)), 'LineStyle', 'none', 'Marker', '.', ...
      'Tag', num2str(j));
    
    times2 = cell2mat({intra_patterns.stim_electrodes(indx1 & indx2 & indx3).time}) - ...
      first_amplitude_offset;
    plot(times2, j*ones(size(times2)), 'LineStyle', 'none', 'Marker', '*', ...
      'Tag', num2str(j));
    
  end
  
  ylim([0 5])
  
  set(h, 'XColor', 'w', 'YColor', 'w', 'Color', 'k', 'YTick', 1:4, ...
    'YTickLabel', {'V1', 'V2', 'V3', 'V4'})
  
end

add_legend(fig, 'none');
linkaxes(get_axes(fig));
xl = xlim();
xlim([0 xl(2)]);
set(fig, 'Color', 'k');

end
