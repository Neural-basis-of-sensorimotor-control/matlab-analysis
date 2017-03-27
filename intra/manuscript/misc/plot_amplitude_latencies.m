function plot_amplitude_latencies(neurons, amplitudes_str)
%Plot all latencies

clf reset
hold on

for i=1:length(neurons)
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron);
  amplitudes = get_items(signal.amplitudes.list, 'tag', amplitudes_str);
  
  for j=1:length(amplitudes)
    x = 1e3*amplitudes(j).latency;
    dummy_y = i*ones(size(x));
    plot(x, dummy_y, 'Marker', '+', 'LineStyle', 'none', 'Color', 'k');
  end
end

set(gca, 'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_tag});
grid on
xlabel('Latencies (ms)')
ylabel('Neuron');
title('Latencies for all neurons')