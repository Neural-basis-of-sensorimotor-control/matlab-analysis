%Figure 3
clc
% clear
fig = figure(7);
clf(fig);

stims_indx = [19 27 40 48];
stims_str = get_intra_motifs(stims_indx);

neurons_indx = [13 14 21];
neurons = get_intra_neurons(neurons_indx);

pretrigger = -.02;
posttrigger = .1;

plot_color = 'k';
plot_avg_color = 'r';

vmin = inf; vmax = -inf;

for i=1:length(neurons)
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  amplitudes = signal.amplitudes;
  v = signal.get_v(true, true, true, true);
  
  for j=1:length(stims_str)
    h = subplot(length(neurons), length(stims_str), (i-1)*length(stims_str)+j);
    cla(h);
    hold(h, 'on');
  
    stim = amplitudes.get('tag', stims_str{j});
    stimtimes = stim.stimtimes;
  
    [v_sweep, t] = sc_get_sweeps(v, 0, stimtimes, pretrigger, posttrigger, signal.dt);
    
    [~, ind_zero] = min(abs(t)); 
    for k=1:size(v_sweep, 2)
        v_sweep(:,k) = v_sweep(:,k) - v_sweep(ind_zero, k);
    end
    
    vmin = min([vmin; v_sweep(:)]);
    vmax = max([vmax; v_sweep(:)]);
    
    for k=1:size(v_sweep,2)
      plot(h, t, v_sweep(:,k), 'Color', plot_color);
      
    end
    
    plot(h, t, mean(v_sweep, 2), 'Color', plot_avg_color);
    
    title(h, sprintf('Cell #%d: %s', i, stims_str{j}));
    grid(h, 'on')
  end
end

linkaxes(get_axes(fig));
ylim(h, [vmin vmax]);

