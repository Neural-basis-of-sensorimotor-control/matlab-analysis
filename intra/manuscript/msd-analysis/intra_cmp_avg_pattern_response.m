function intra_cmp_avg_pattern_response(fig, patterns_indx, neurons_indx)

clc

if isnumeric(fig)
  fig = figure(fig);
end
clf(fig, 'reset');

%patterns_indx = [10 4 12];
if isnumeric(patterns_indx)
  patterns_str = get_intra_patterns(patterns_indx);
else
  patterns_str = patterns_indx;
end

%neurons_indx = [13 14 21];
neurons = get_intra_neurons(neurons_indx);

pretrigger = -.02;
posttrigger = .5;

plot_color = 'k';
vmin = inf; vmax = -inf;

for i=1:length(neurons)
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  v = signal.get_v(true, true, true, true);
  
  for j=1:length(patterns_str)
    h = subplot(length(neurons), length(patterns_str), (i-1)*length(patterns_str)+j);
    cla(h);
    hold(h, 'on');
  
    stim = signal.parent.textchannels.get('tag', 'TextMark').triggers.get('tag', patterns_str{j});%   .get('tag', patterns_str{j});
    stimtimes = stim.gettimes(0, inf);
  
    [v_sweep, t] = sc_get_sweeps(v, 0, stimtimes, pretrigger, posttrigger, signal.dt);
    
    v_avg = mean(v_sweep, 2);
    vmin = min([vmin; v_avg]);
    vmax = max([vmax; v_avg]);
    
    plot(h, t, v_avg, 'Color', plot_color);
    title(h, sprintf('Avg response: %s, %s', neuron.file_tag, patterns_str{j}));
    grid(h, 'on')
  end
end

linkaxes(get_axes(fig));
ylim(h, [vmin vmax]);

