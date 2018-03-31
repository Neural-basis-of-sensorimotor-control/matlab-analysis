function intra_generate_figs_2

clc
%close all
clear
reset_fig_indx

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

xxx1();
xxx2();

end


function xxx1()

nbr_of_electrodes = 1;
str_stims         = get_intra_motifs();
neurons           = intra_get_neurons();
nbr_of_neurons    = length(neurons);

[~, indx] = get_electrode(str_stims);
str_stims = str_stims(indx == 1);

dim         = [nbr_of_electrodes, nbr_of_neurons];
enc_heights = cell(dim);
enc_latency = cell(dim);
enc_width   = cell(dim);

for i_neuron=1:nbr_of_neurons
  
  signal = sc_load_signal(neurons(i_neuron));
  
  for j=1:length(str_stims)
    
    amplitude = signal.amplitudes.get('tag', str_stims{j});
    
    if isempty(amplitude)
      continue
    end
    
    height    = amplitude.height;
    latency   = amplitude.latency;
    width     = amplitude.width;
    
    pos       = height > 0;
    height    = height(pos);
    latency   = latency(pos);
    width     = width(pos);
    
    [~, electrode_indx]         = get_electrode(amplitude);
    
    enc_heights(electrode_indx, i_neuron) = {concat_list(enc_heights{electrode_indx, i_neuron}, height)};
    enc_latency(electrode_indx, i_neuron) = {concat_list(enc_latency{electrode_indx, i_neuron}, latency)};
    enc_width(electrode_indx, i_neuron)   = {concat_list(enc_width{electrode_indx, i_neuron}, width)};
    
  end
  
end

plot_disparity(enc_latency, enc_heights,  ...
  'Latency [ms]', 'Height [mV]', intra_file_tag_to_neuron_indx({neurons.file_tag}, neurons))
plot_disparity(enc_width, enc_heights, ...
  'Time to peak [ms]', 'Height [mV]', intra_file_tag_to_neuron_indx({neurons.file_tag}, neurons))

end

function xxx2()

neurons = intra_get_neurons(7);

f_plot_3d_single_stim = incr_fig_indx();
clf
grid on

f_plot_3d_all = incr_fig_indx();
clf
grid on

load intra_data.mat

str_single = get_intra_single();

nbr_of_electrodes = 4;
nbr_of_subplots   = nbr_of_electrodes * length(neurons);

for i_neuron=1:length(neurons)
  
  sc_debug.print(i_neuron, length(neurons));
  
  neuron = neurons(i_neuron);
  signal = sc_load_signal(neuron);
  
  figure(f_plot_3d_all)
  hold on
  title([neuron.file_tag]);
  xlabel('height')
  ylabel('latency ms')
  zlabel('time to peak ms')  
  
  for i_single=1:length(str_single)
    
    tmp_single_stim = str_single{i_single};
    
    amplitude = signal.amplitudes.get('tag', tmp_single_stim);
    
    if isempty(amplitude)
      continue
    end
    
    height  = amplitude.height;
    latency = 1e3*amplitude.latency;
    width   = 1e3*amplitude.width;
    
    [str_electrode, electrode_indx] = get_electrode(amplitude);
    
    if electrode_indx == 3
      
      figure(f_plot_3d_single_stim)
      hold on
      title(sprintf('%s, V%d', neuron.file_tag, electrode_indx));
      plot3(height, latency, width, 'k.')
      
    end
    
    figure(f_plot_3d_all)
    plot3(height, latency, width, 'LineStyle', 'none', 'Marker', '.', ...
      'Tag', str_electrode)
    
  end
  
  figure(f_plot_3d_all)
  view(gca, 3)
  
end

add_legend(get_axes(f_plot_3d_all), true);

figure(f_plot_3d_all)
axis tight

figure(f_plot_3d_single_stim)
axis tight

for i_subplot=1:nbr_of_subplots
  
  figure(f_plot_3d_single_stim)
  
  view(3)
  
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
    ylabel('latency')
    zlabel('time to peak')
    
  end
  
  
  
end

end


function plot_disparity(x, y, str_x, str_y, tags)

lower_percentile = 25;
upper_percentile = 75;

f = [];

for i=1:size(x, 1)
  
  f = add_to_list(f, incr_fig_indx());
  clf('reset')
  hold on
  title(sprintf('V%d, %d - %d percentiles', ...
    i, lower_percentile, upper_percentile), ...
    'FontSize', 14);
  xlabel(str_x)
  ylabel(str_y)
  
end

for i=1:size(x, 2)
  
  for j=1:size(x, 1)
    
    xmean = mean(x{j, i});
    xupper = prctile(x{j, i}, upper_percentile);
    xlower = prctile(x{j, i}, lower_percentile);
    
    ymean = mean(y{j, i});
    yupper = prctile(y{j, i}, upper_percentile);
    ylower = prctile(y{j, i}, lower_percentile);
    
    figure(f(j));
    
    plot([xlower xupper], ymean*[1 1], ':', 'LineWidth', 2, 'Tag', tags{i})
    plot(xlower, ymean, '<',  'LineWidth', 2, 'Tag', tags{i})
    plot(xupper, ymean, '>',  'LineWidth', 2, 'Tag', tags{i})
    
    plot(xmean*[1 1], [ylower yupper], ':', 'LineWidth', 2, 'Tag', tags{i})
    plot(xmean, ylower, 'v', 'LineWidth', 2, 'Tag', tags{i})
    plot(xmean, yupper, '^',  'LineWidth', 2, 'Tag', tags{i})
    
  end
  
end

add_legend(f, false, false, 'Location', 'EastOutside');

end
