function intra_compare_amplitude_heights(neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

str_stims = get_intra_motifs();
neurons = intra_get_neurons();

if nargin
  neurons = neurons(neuron_indx);
end

[~, indx] = get_electrode(str_stims);
[~, indx] = sort(indx);
str_stims = str_stims(indx);

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  signal = sc_load_signal(neurons(i));
  
  incr_fig_indx();
  clf
  
  h1 = subplot(10, 1, 3:10);
  hold on
  
  response_rate = nan(size(str_stims));
  
  for j=1:length(str_stims)
    
    amplitude   = signal.amplitudes.get('tag', str_stims{j});
    heights     = amplitude.height;
    heights     = heights(heights>0);
    str_electrode = get_electrode(amplitude);
    
    plot(j*ones(size(heights)), heights, 'k+', 'Tag', str_electrode);
    response_rate(j) = length(heights) / amplitude.N;
    
  end
  
  set(gca, 'XTick', 1:length(str_stims), 'XTickLabel', str_stims, ...
    'XTickLabelRotation', 270);
  ylabel('EPSP amplitude [mV]')
  grid on
  title(neurons(i).file_tag)
  
  h2 = subplot(10, 1, 1);
  bar(100*response_rate)
  set(gca, 'XTick', []);
  xlim([0 (length(str_stims)+1)])
  ylim([0 100])
  title('Response rate');
  grid on
  ylabel('%')
  
  linkaxes([h1 h2], 'x');
  
  add_legend(h1, 'no');
  
end
  
  