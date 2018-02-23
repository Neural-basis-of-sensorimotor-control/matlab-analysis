clear

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

reset_fig_indx();

for i=1:length(neurons)
  
  signal = sc_load_signal(neurons(i));
  
  incr_fig_indx();
  clf
  
  h1 = subplot(10, 1, 2:10);
  hold on
  
  response_rate = nan(size(str_stims));
  
  for j=1:length(str_stims)
    
    amplitude = signal.amplitudes.get('tag', str_stims{j});
    heights   = amplitude.height; 
    
    plot(j*ones(size(heights)), heights, 'k+');
    response_rate(j) = length(heights) / amplitude.N;
    
  end
  
  set(gca, 'XTick', 1:length(str_stims), 'XTickLabel', str_stims, ...
    'XTickLabelRotation', 270);
  ylabel('EPSP amplitude [mV]')
  grid on
  
  h2 = subplot(10, 1, 1);
  bar(100*response_rate)
  set(gca, 'XTick', []);
  title(neurons(i).file_tag)
  
  linkaxes([h1 h2], 'x');
  
  xlim([0 (length(str_stims)+1)])
  ylabel('Response rate %');
  
end
  
  