clear

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

reset_fig_indx();

n_excitatory = 100;
v_excitatory = .2;
%p_excitatory = .2;

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  signal = sc_load_signal(neurons(i));
  
  incr_fig_indx();
  clf
  
  h1 = subplot(10, 1, 2:10);
  hold on
  
  response_rate = nan(size(str_stims));
  recruitment   = nan(size(str_stims));
  
  for j=1:length(str_stims)
    
    amplitude = signal.amplitudes.get('tag', str_stims{j});
    heights   = amplitude.height;
    
    plot(j*ones(size(heights)), heights, 'k+');
    response_rate(j) = length(heights) / amplitude.N;
    
    %v_excitatory = min(diff(sort(heights(heights>0))));
    
    %if isempty(v_excitatory) || isinf(v_excitatory) || ~v_excitatory
    %  v_excitatory = .2;
    %end
    
    p_excitatory = mean(heights(heights>0))/(n_excitatory*v_excitatory);
    recruitment(j) = p_excitatory;
    
    simulated_height = arrayfun(...
      @(~) intra_simulate_amplitude(n_excitatory, v_excitatory, p_excitatory), ...
      1:nnz(heights>0));
    
    
    fprintf('%d / %d\n', length(unique(simulated_height)), length(simulated_height));
    plot(j*ones(size(simulated_height))+.5, simulated_height, 'r+');
    
    if j==1
      legend('manual', 'simulated');
    end
    
    title(neurons(i).file_tag)
    
    title(neurons(i).file_tag)
    
    linkaxes([h1 h2], 'x');
    
    xlim([0 (length(str_stims)+1)])
    ylabel('Response rate %');
    
    xlim([0 (length(str_stims)+1)])
    ylim([0 100])
    title('Response rate');
    grid on
    ylabel('%')
    
    h3 = subplot(10, 1, 2);
    bar(100*recruitment)
    set(gca, 'XTick', []);
    xlim([0 (length(str_stims)+1)])
    ylim([0 100])
    title('Simulated recruitment rate');
    grid on
    ylabel('%')
    
    linkaxes([h1 h2 h3], 'x');
    
    
  end
  
end