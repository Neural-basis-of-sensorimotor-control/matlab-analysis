function intra_compute_r_value(neuron_indx)

sc_settings.set_current_settings_tag(sc_settings.get_intra_analysis_tag());
sc_debug.set_mode(true);

latency_offset    = 4e-3;
nbr_of_electrodes = 4;
str_stims         = get_intra_motifs();%get_intra_single();%
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
enc_abs_latency = cell(dim);
enc_net_latency = cell(dim);
enc_width   = cell(dim);

mean_height = 0;
mean_abs_latency = 0;
mean_width = 0;


all_r2_height_abs_latency = [];
all_r2_height_net_latency = [];
all_r2_height_width     = [];
all_r2_abs_latency_width    = [];
all_r2_net_latency_width    = [];

for i_neuron=1:nbr_of_neurons
  
  sc_debug.print(i_neuron, length(neurons));
  
  signal = sc_load_signal(neurons(i_neuron));
  
  tmp_height = cell(nbr_of_electrodes, 1);
  tmp_abs_latency = cell(nbr_of_electrodes, 1);
  tmp_width = cell(nbr_of_electrodes, 1);
  
  for i_stim=1:length(str_stims)
    
    amplitude = signal.amplitudes.get('tag', str_stims{i_stim});
    
    if isempty(amplitude)
      continue
    end
    
    height    = amplitude.height;
    abs_latency   = amplitude.latency;
    net_latency   = amplitude.latency - latency_offset;
    width     = amplitude.width;
    
    pos         = height > 0;
    height      = height(pos);
    abs_latency = abs_latency(pos);
    net_latency = net_latency(pos);
    width       = width(pos);
    
    [~, electrode_indx]         = get_electrode(amplitude);
    
    tmp_height(electrode_indx) = {concat_list(tmp_height{electrode_indx}, height)};
    tmp_abs_latency(electrode_indx) = {concat_list(tmp_abs_latency{electrode_indx}, abs_latency)};
    tmp_width(electrode_indx) = {concat_list(tmp_width{electrode_indx}, width)};
    
    enc_heights(electrode_indx, i_neuron) = {concat_list(enc_heights{electrode_indx, i_neuron}, height)};
    enc_abs_latency(electrode_indx, i_neuron) = {concat_list(enc_abs_latency{electrode_indx, i_neuron}, abs_latency)};
    enc_net_latency(electrode_indx, i_neuron) = {concat_list(enc_net_latency{electrode_indx, i_neuron}, net_latency)};
    enc_width(electrode_indx, i_neuron)   = {concat_list(enc_width{electrode_indx, i_neuron}, width)};
    
    if length(height) > 1
      
      r2_height_abs_latency    = corrcoef(height, abs_latency).^2;
      r2_height_net_latency    = corrcoef(height, net_latency).^2;
      r2_height_time2peak  = corrcoef(height, width).^2;
      r2_abs_latency_time2peak = corrcoef(abs_latency, width).^2;
      r2_net_latency_time2peak = corrcoef(net_latency, width).^2;
      
      all_r2_height_abs_latency = add_to_list(all_r2_height_abs_latency, r2_height_abs_latency(1, 2));
      all_r2_height_net_latency = add_to_list(all_r2_height_net_latency, r2_height_net_latency(1, 2));
      all_r2_height_width     = add_to_list(all_r2_height_width, r2_height_time2peak(1, 2));
      all_r2_abs_latency_width    = add_to_list(all_r2_abs_latency_width, r2_abs_latency_time2peak(1, 2));
      all_r2_net_latency_width    = add_to_list(all_r2_net_latency_width, r2_net_latency_time2peak(1, 2));
      
    end
    
  end
  
  for i_electrode=1:nbr_of_electrodes
    
    mean_height = add_to_list(mean_height, mean(tmp_height{i_electrode}));
    mean_abs_latency = add_to_list(mean_abs_latency, mean(tmp_abs_latency{i_electrode}));
    mean_width = add_to_list(mean_width, mean(tmp_width{i_electrode}));
    
  end

end

plot_disparity(enc_heights, enc_abs_latency, ...
  '''Height [mV]''', '''Abs latency [s]''', {neurons.file_tag})
plot_disparity(enc_heights, enc_width, ...
  '''Height [mV]''', '''Time to peak [s]''', {neurons.file_tag})
plot_disparity(enc_abs_latency, enc_width, '''Abs latency [s]''', ...
  '''Time to peak [s]''', {neurons.file_tag})

fprintf('Height (mean of mean)\t%f\t%f\n', mean(mean_height), std(mean_height));
fprintf('Abs latency (mean of mean)\t%f\t%f\n', mean(mean_abs_latency), std(mean_abs_latency));
fprintf('Width (mean of mean)\t%f\t%f\n', mean(mean_width), std(mean_width));

fprintf('Height vs abs latency\t%f\t%f\n', mean(all_r2_height_abs_latency), std(all_r2_height_abs_latency));
fprintf('Height vs time to peak\t%f\t%f\n', mean(all_r2_height_width), std(all_r2_height_width));
fprintf('Abs latency vs time to peak\t%f\t%f\n', mean(all_r2_abs_latency_width), std(all_r2_abs_latency_width));

fprintf('Height vs abs latency\t%f\t%f\n', mean(all_r2_height_abs_latency), std(all_r2_height_abs_latency));
fprintf('Height vs net latency\t%f\t%f\n', mean(all_r2_height_net_latency), std(all_r2_height_net_latency));
fprintf('Height vs time to peak\t%f\t%f\n', mean(all_r2_height_width), std(all_r2_height_width));
fprintf('Abs latency vs time to peak\t%f\t%f\n', mean(all_r2_abs_latency_width), std(all_r2_abs_latency_width));
fprintf('Net latency vs time to peak\t%f\t%f\n', mean(all_r2_net_latency_width), std(all_r2_net_latency_width));

h_cov = [];
abs_l_cov = [];
net_l_cov = [];
w_cov = [];

for i_electrode=1:nbr_of_electrodes
  for i_stim=1:nbr_of_neurons
    
    h_cov = add_to_list(h_cov, std(enc_heights{i_electrode, i_stim})/mean(enc_heights{i_electrode, i_stim}));
    abs_l_cov = add_to_list(abs_l_cov, std(enc_abs_latency{i_electrode, i_stim})/mean(enc_abs_latency{i_electrode, i_stim}));
    net_l_cov = add_to_list(net_l_cov, std(enc_net_latency{i_electrode, i_stim})/mean(enc_net_latency{i_electrode, i_stim}));
    w_cov = add_to_list(w_cov, std(enc_width{i_electrode, i_stim})/mean(enc_width{i_electrode, i_stim}));
    
  end
end

fprintf('%g\t%g\n', mean(h_cov), std(h_cov));
fprintf('%g\t%g\n', mean(abs_l_cov), std(abs_l_cov));
fprintf('%g\t%g\n', mean(net_l_cov), std(net_l_cov));
fprintf('%g\t%g\n', mean(w_cov), std(w_cov));

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
