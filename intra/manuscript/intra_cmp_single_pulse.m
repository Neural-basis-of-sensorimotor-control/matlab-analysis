%Figure 1
clc
clear
fig = gcf;
clf(fig);
stim_electrode = '3';

stims_str = get_single_amplitudes(stim_electrode);
neuron_indx = 11;
neuron = get_intra_neurons(neuron_indx);

pretrigger = -.02;
posttrigger = .1;

plot_color = 'k';

signal = sc_load_signal(neuron);
amplitudes = signal.amplitudes;
v = signal.get_v(true, true, true, true);
h = gca;
cla(h);
hold(h, 'on');

stims = amplitudes.match(stims_str);
for i=1:length(stims)
  stim = stims{i};
  stimtimes = stim.stimtimes;
  
  [v_sweep, t] = sc_get_sweeps(v, 0, stimtimes, pretrigger, posttrigger, signal.dt);
  
  for k=1:size(v_sweep,2)
    plot(h, t, v_sweep(:,k), 'Color', plot_color);
  end
end

xlabel(h, 'Time [s]');
ylabel(h, 'Amplitude [mV]');
title(h, sprintf('Cell %s: Single pulse stim electrode %s', neuron.file_str, stim_electrode));
