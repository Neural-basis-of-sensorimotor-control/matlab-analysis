function intra_plot_3d_epsps(neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

neurons = intra_get_neurons();

if nargin
  neurons = neurons(neuron_indx);
end

fig1 = incr_fig_indx();
clf

fig2 = incr_fig_indx();
clf

fig3 = incr_fig_indx();
clf

fig4 = incr_fig_indx();
clf

fig5 = incr_fig_indx();
clf

fig6 = incr_fig_indx();
clf

load intra_data.mat

str_single = {'1p electrode 1#V1#1'
  '1p electrode 1#V1#2'
  '1p electrode 1#V1#3'
  '1p electrode 1#V1#4'
  '1p electrode 1#V1#5'
  '1p electrode 2#V2#1'
  '1p electrode 2#V2#2'
  '1p electrode 2#V2#3'
  '1p electrode 2#V2#4'
  '1p electrode 2#V2#5'
  '1p electrode 3#V3#1'
  '1p electrode 3#V3#2'
  '1p electrode 3#V3#3'
  '1p electrode 3#V3#4'
  '1p electrode 3#V3#5'
  '1p electrode 4#V4#1'
  '1p electrode 4#V4#2'
  '1p electrode 4#V4#3'
  '1p electrode 4#V4#4'
  '1p electrode 4#V4#5'};

nbr_of_electrodes = 4;
nbr_of_subplots   = nbr_of_electrodes * length(neurons);

figure(fig6)
subplot(2, 2, 1)
title('Height coefficient of variation single pulses')
xlabel('Neuron')
set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
  'XTickLabelRotation', 270)
xlim([0 length(neurons)+1])
ylabel('Coefficient of variation');
grid on
hold on
set(gca, 'Color', 'k')

subplot(2, 2, 2)
title('Latency - 4 ms coefficient of variation single pulses')
xlabel('Neuron')
set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
  'XTickLabelRotation', 270)
xlim([0 length(neurons)+1])
ylabel('Coefficient of variation');
grid on
hold on
set(gca, 'Color', 'k')

subplot(2, 2, 3)
title('Time to peak coefficient of variation single pulses')
xlabel('Neuron')
set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
  'XTickLabelRotation', 270)
xlim([0 length(neurons)+1])
ylabel('Coefficient of variation');
grid on
hold on
set(gca, 'Color', 'k')

all_heights   = [];
all_widths    = [];
all_latencies = [];

for i_neuron=1:length(neurons)
  
  sc_debug.print(i_neuron, length(neurons));
  
  neuron = neurons(i_neuron);
  signal = sc_load_signal(neuron);
  
  figure(fig5)
  h_axes = sc_square_subplot(length(neurons), i_neuron);
  hold on
  title([neuron.file_tag ': height vs latency']);
  xlabel('height')
  ylabel('latency - 4 ms')
  zlabel('time to peak')
  grid on
  
  
  for i_single=1:length(str_single)
    
    tmp_single_stim = str_single{i_single};
    
    amplitude = signal.amplitudes.get('tag', tmp_single_stim);
    
    if isempty(amplitude)
      continue
    end
        
    height  = amplitude.height;
    latency = amplitude.latency - 4e-3;
    width   = amplitude.width;
    
    all_heights   = concat_list(all_heights, height);
    all_widths    = concat_list(all_widths, width);
    all_latencies = concat_list(all_latencies, latency);
    
    [str_electrode, electrode_indx] = get_electrode(amplitude);
    
    figure(fig1)
    sc_square_subplot(nbr_of_subplots, (i_neuron-1)*nbr_of_electrodes + electrode_indx);
    hold on    
    title(sprintf('%s, V%d', neuron.file_tag, electrode_indx));
    plot3(height, latency, width, 'k.')
    
    figure(fig2)
    sc_square_subplot(nbr_of_subplots, (i_neuron-1)*nbr_of_electrodes + electrode_indx);
    hold on    
    title(sprintf('%s, V%d', neuron.file_tag, electrode_indx));
    plot(height, latency, 'k.')
    
    figure(fig3)
    sc_square_subplot(nbr_of_subplots, (i_neuron-1)*nbr_of_electrodes + electrode_indx);
    hold on
    title(sprintf('%s, V%d', neuron.file_tag, electrode_indx));
    plot(height, width, 'k.')
    
    figure(fig4)
    sc_square_subplot(nbr_of_subplots, (i_neuron-1)*nbr_of_electrodes + electrode_indx);
    hold on
    title(sprintf('%s, V%d', neuron.file_tag, electrode_indx));
    plot(latency, width, 'k.')
    
    axes(h_axes)
    plot3(height, latency, width, 'LineStyle', 'none', 'Marker', '.', ...
      'Tag', str_electrode)
    
    figure(fig6)
    subplot(2, 2, 1)
    plot(i_neuron, std(height)/mean(height), '+', 'Tag', str_electrode);
    subplot(2, 2, 2)
    plot(i_neuron, std(latency)/mean(latency), '+', 'Tag', str_electrode);
    subplot(2, 2, 3)
    plot(i_neuron, std(width)/mean(width), '+', 'Tag', str_electrode);
    
  end
  
  view(h_axes, 3)
  
end

add_legend(get_axes(fig5), true);
add_legend(get_axes(fig6), true, true, 'TextColor', 'w', ...
  'Location', 'EastOutside');

for i_subplot=1:nbr_of_subplots
  
  figure(fig1)
  sc_square_subplot(nbr_of_subplots, i_subplot);
    
  view(3)
  grid on
  
  xl = xlim;
  yl = ylim;
  zl = zlim;
  
  if xl(1) > 0
    xlim([0 xl(2)])
  end
  
  if yl(1) > 0
    ylim([0 yl(2)])
  end
  
  if zl(1) > 0
    zlim([0 zl(2)])
  end
  
  if i_subplot == 1
    
    xlabel('height')
    ylabel('latency - 4 ms')
    zlabel('time to peak')
  
  end
  
  figure(fig2)
  sc_square_subplot(nbr_of_subplots, i_subplot);
  
  grid on
  
  if i_subplot == 1
    
    xlabel('height')
    ylabel('latency - 4 ms')
  
  end

  xl = xlim;
  yl = ylim;
  
  if xl(1) > 0
    xlim([0 xl(2)])
  end
  
  if yl(1) > 0
    ylim([0 yl(2)])
  end
  
  figure(fig3)
  sc_square_subplot(nbr_of_subplots, i_subplot);
  
  grid on
  
  xl = xlim;
  yl = ylim;
  
  if xl(1) > 0
    xlim([0 xl(2)])
  end
  
  if yl(1) > 0
    ylim([0 yl(2)])
  end
  
  if i_subplot == 1
    
    xlabel('height')
    ylabel('time to peak')
  
  end
  
  figure(fig4)
  sc_square_subplot(nbr_of_subplots, i_subplot);
  
  grid on
  
  xl = xlim;
  yl = ylim;
  
  if xl(1) > 0
    xlim([0 xl(2)])
  end
  
  if yl(1) > 0
    ylim([0 yl(2)])
  end
  
  if i_subplot == 1
    
    xlabel('latency - 4 ms')
    ylabel('time to peak')
  
  end
  
end

figure(fig6)
subplot(2, 2, 1)
yl = ylim;
if yl(1) > 0
  ylim([0 yl(2)])
end

subplot(2, 2, 2)
yl = ylim;
if yl(1) > 0
  ylim([0 yl(2)])
end

subplot(2, 2, 3)
yl = ylim;
if yl(1) > 0
  ylim([0 yl(2)])
end

fprintf('Height\t%f\t%f\t%f\n', mean(all_heights), std(all_heights), ...
  std(all_heights)/mean(all_heights));
fprintf('Latency\t%f\t%f\t%f\n', mean(all_latencies), std(all_latencies), ...
  std(all_latencies)/mean(all_latencies));
fprintf('Time to peak\t%f\t%f\t%f\n', mean(all_widths), std(all_widths), ...
  std(all_widths)/mean(all_widths));

end