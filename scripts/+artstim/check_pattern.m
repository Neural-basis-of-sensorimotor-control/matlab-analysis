clear
load intra_data.mat

reset_fig_indx()

incr_fig_indx()
clf
hold on
grid on

for i=1:length(intra_patterns.patterns)
  
  times = cell2mat({intra_patterns.patterns(i).stim_electrodes.time});
  times = times - min(times);
  
  plot(times, i*ones(size(times)), '+');
  
end

ylim([0 (length(intra_patterns.patterns)+1)])

incr_fig_indx()
clf


for i=1:length(intra_patterns.patterns)
  
  pattern = intra_patterns.patterns(i);
  
  sc_square_subplot(length(intra_patterns.patterns), i);
  hold on
  
  for j=1:4
    indx = cellfun(@(x) strcmp(x, sprintf('V%d', j)), pattern.types);
    times = cell2mat({pattern.stim_electrodes(indx).time});
    plot(times, j*ones(size(times)), '+')
  end
  
  set(gca, 'YTick', 1:4)
  
  title(pattern.name)
  
end

linkaxes(get_axes(gcf))
ylim([0 5])

incr_fig_indx()
clf
set(gcf, 'Color', 'k');
for i=1:length(intra_patterns.patterns)
  
  pattern = intra_patterns.patterns(i);
  
  for j=1:4
    
    sc_square_subplot(4, j);
    hold on
    set(gca, 'Color', 'k');

  
    indx  = cellfun(@(x) strcmp(x, sprintf('V%d', j)), pattern.types);
    times = cell2mat({pattern.stim_electrodes(indx).time});
    times = times - min(times);
    
    plot(times, i*ones(size(times)), '+')
  
  end
  
end


for i=1:4
  
  sc_square_subplot(4, i);
  set(gca, 'YTick', 1:8)
  set(gca, 'YTickLabel', {intra_patterns.patterns.name})
  title(sprintf('V%d', i));
  ylim([0 9])
  grid on

end

incr_fig_indx()
clf

sc_counter.reset_counter([]);
indx_patterns = [1 5];

for i=indx_patterns%1:length(intra_patterns.patterns)
  
  pattern = intra_patterns.patterns(i);
  sc_counter.increment([]);
  
  for j=1:4
    
    sc_square_subplot(4, j);
    hold on
  
    indx  = cellfun(@(x) strcmp(x, sprintf('V%d', j)), pattern.types);
    times = cell2mat({pattern.stim_electrodes(indx).time});
    
    switch sc_counter.get_count([])
      case 1
        marker = '+';
      case 2
        marker = 'o';
      otherwise
        error('HHH')
    end
    
    plot(times, ones(size(times)), marker, 'Tag', ...
      intra_patterns.patterns(i).name)
  
  end
  
end


for i=1:4
  
  sc_square_subplot(4, i);
  %set(gca, 'YTick', 1:8)
  %set(gca, 'YTickLabel', {intra_patterns.patterns.name})
  
  str_title = sprintf('V%d', i);
  
  for j=1:length(indx_patterns)
    str_title = [str_title ' ' intra_patterns.patterns(indx_patterns(j)).name];
  end
  
  title(str_title);
  ylim([0 2])
  grid on

end




