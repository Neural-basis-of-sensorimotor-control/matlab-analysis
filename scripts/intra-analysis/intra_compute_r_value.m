function intra_compute_r_value(neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

nbr_of_electrodes = 4;
str_stims         = get_intra_motifs();
neurons           = intra_get_neurons();
nbr_of_neurons    = length(neurons);

if nargin
  neurons = neurons(neuron_indx);
end

[~, indx] = get_electrode(str_stims);
[~, indx] = sort(indx);
str_stims = str_stims(indx);

dim         = [nbr_of_electrodes, nbr_of_neurons];
enc_heights = cell(dim);
enc_latency = cell(dim);
enc_width   = cell(dim);

all_r2_height_latency = [];
all_r2_height_t2p     = [];
all_r2_latency_t2p    = [];

for i_neuron=1:nbr_of_neurons
  
  sc_debug.print(i_neuron, length(neurons));
  
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
    
    if length(height) > 1
      
      r2_height_latency    = corrcoef(height, latency).^2;
      r2_height_time2peak  = corrcoef(height, width).^2;
      r2_latency_time2peak = corrcoef(latency, width).^2;
      
      all_r2_height_latency = add_to_list(all_r2_height_latency, r2_height_latency(1, 2));
      all_r2_height_t2p     = add_to_list(all_r2_height_t2p, r2_height_time2peak(1, 2));
      all_r2_latency_t2p    = add_to_list(all_r2_latency_t2p, r2_latency_time2peak(1, 2));
      
    end
    
  end
  
end

plot_disparity(enc_heights, enc_latency, ...
  '''Height [mV]''', '''Latency [s]''', {neurons.file_tag})
plot_disparity(enc_heights, enc_width, ...
  '''Height [mV]''', '''Time to peak [s]''', {neurons.file_tag})
plot_disparity(enc_latency, enc_width, '''Latency [s]''', ...
  '''Time to peak [s]''', {neurons.file_tag})

fprintf('Height vs latency\t%f\t%f\n', mean(all_r2_height_latency), std(all_r2_height_latency));
fprintf('Height vs time to peak\t%f\t%f\n', mean(all_r2_height_t2p), std(all_r2_height_t2p));
fprintf('Latency vs time to peak\t%f\t%f\n', mean(all_r2_latency_t2p), std(all_r2_latency_t2p));

end

function plot_disparity(x, y, str_x, str_y, tags)

lower_percentile = 25;
upper_percentile = 75;

f = [];
for i=1:size(x, 1)
  
  f = add_to_list(f, incr_fig_indx());
  clf('reset')
  set(gcf, 'Color', 'k')
  hold on
  title(sprintf('V%d, %d - %d percentiles', ...
    i, lower_percentile, upper_percentile), ...
    'Color', 'w', 'FontSize', 14);
  xlabel(str_x)
  ylabel(str_y)
  grid on
  set(gca, 'Color', 'k')
  set(gca, 'XColor', 'w')
  set(gca, 'YColor', 'w')
  
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
    
    plot([xlower xupper], ymean*[1 1], ':', 'Tag', tags{i})
    plot(xlower, ymean, '<',  'LineWidth', 2, 'Tag', tags{i})
    plot(xupper, ymean, '>',  'LineWidth', 2, 'Tag', tags{i})
    
    plot(xmean*[1 1], [ylower yupper], ':', 'Tag', tags{i})
    plot(xmean, ylower, 'v', 'LineWidth', 2, 'Tag', tags{i})
    plot(xmean, yupper, '^',  'LineWidth', 2, 'Tag', tags{i})
    
  end
  
end

add_legend(f, false, true, 'Location', 'EastOutside', 'TextColor', 'w');

end
