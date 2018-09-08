function intra_plot_states()

sc_settings.set_current_settings_tag(sc_settings.tags.INTRA);
sc_debug.set_mode(true);

intra_load_settings
intra_load_constants

reset_fig_indx();

%%
pretrigger = -.1;
posttrigger = .2;
nbrofcoeff = 20;

for i=1:length(neurons)
  
  neuron   = neurons(i);
  
  for j=1:length(str_stims)
    
    str_stim  = str_stims{j};
    signal    = sc_load_signal(neuron);
    amplitude = signal.amplitudes.get('tag', str_stim);
    v         = signal.get_v(true, true, true, true);
    
    [sweeps, time] = sc_get_sweeps(v, 0, amplitude.gettimes(0, inf), pretrigger, ...
      posttrigger, signal.dt);
    
    [~, ind_zero] = min(abs(time));
    
    f = incr_fig_indx();
    f.Name = [neuron.file_tag ' ' amplitude.tag];
    clf
    subplot(1,2,1)
    title([neuron.file_tag ' ' amplitude.tag ' (raw data signal)']);
    hold on
    
    for k=1:size(sweeps, 2)
      
      tmp_sweep = sweeps(:, k) - sweeps(ind_zero, k);
      plot(time, tmp_sweep);
      
    end
    
    x = sweeps(time > 0, :);
    c = pca(x);
    c = c(1:nbrofcoeff, :);
    
    subplot(1,2,2)
    title([neuron.file_tag ' ' amplitude.tag ' (PCA signal, ' num2str(nbrofcoeffs) ' dimensions)']);
    hold on
    
    for k=1:size(sweeps, 2)
      
      plot(c(:,k));
      
    end
  end
end

end
