%Figure 4
%Create mosaic

function make_mosaic(indx)

evaluation_fcns = {@get_epsp_amplitude_single_pulse
  @get_epsp_width_single_pulse
  @get_onset_latency_single_pulse
  @get_epsp_amplitude_abs
  @get_epsp_width_abs
  @get_onset_latency_abs
  @get_epsp_amplitude_abs
  @get_epsp_width_abs
  @get_onset_latency_abs
  @get_response_fraction};

titlestr = {'Amplitude height [single pulse response = 1], ''*'' = negative single pulse'
  'Time to peak [single pulse response = 1]'
  'Latency [single pulse response = 1]'
  'Amplitude height [max value = 1]'
  'Time to peak [max value = 1]'
  'Latency [max value = 1]'
  'Amplitude height [absolute value]'
  'Time to peak [absolute value]'
  'Latency [absolute value]'
  'Response fraction ''*'' = below threshold'};

normalization_fcns = {[]
  []
  []
  @normalize_to_max
  @normalize_to_max
  @normalize_to_max
  []
  []
  []
  []
  };

apply_thresholds = [true(9,1); false(1)];

for i=1:length(indx)
  
  tmp_evaluation_fcn = evaluation_fcns{indx(i)};
  tmp_normalization_fcn = normalization_fcns{indx(i)};
  tmp_apply_thresholds = apply_thresholds(indx(i));
  tmp_figure = incr_fig_indx();
  tmp_titlestr = titlestr{indx(i)};
  
  fprintf('%d (%d)\n', i, length(indx));
  make_mosaic_subfct(tmp_evaluation_fcn,tmp_normalization_fcn, ...
    tmp_apply_thresholds, tmp_figure);
  title(tmp_titlestr);
  add_figure_filename(gca);
end

neurons = get_intra_neurons();
stims_str = get_intra_motifs();

incr_fig_indx();
clf('reset')
hold on

for i=1:length(neurons)
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(stims_str)
    amplitude = signal.amplitudes.get('tag', stims_str{j});
    plot(i, amplitude.userdata.fraction_detected, '.', 'Tag', 'Amplitude response');
  end
  
  avg_spont = signal.userdata.avg_spont_activity;
  std_spont = signal.userdata.std_spont_activity;
  
  plot(i, avg_spont, '+', 'Tag', 'Spontaneuous activity');
  plot(i, avg_spont+3*std_spont, '+', 'Tag', 'Threshold response');
end

set(gca,'XTick',1:length(neurons),'XTickLabel',{neurons.file_tag}, ...
  'XTickLabelRotation', 270, 'Color', [0 0 0]);
ylabel('Response fraction');
ylim([0 1]);
add_legend(gca);
add_figure_filename(gca);

end


function make_mosaic_subfct(mosaik_fcn, normalization_fcn, apply_threshold, ...
  fig)

neurons = get_intra_neurons();
nbr_of_neurons = length(neurons);
stims_str = get_intra_motifs();
nbr_of_stims = length(stims_str);
v = nan(nbr_of_stims, nbr_of_neurons);
norm_constant_is_negative = false(size(v));

for i=1:nbr_of_neurons
  fprintf('\t%d (%d)\n', i, nbr_of_neurons);
  signal = sc_load_signal(neurons(i));
  activity_threshold = get_activity_threshold(signal);
  
  for j=1:nbr_of_stims
    stim = get_item(signal.amplitudes.cell_list, stims_str{j});
    
    if ~apply_threshold || ...
        stim.userdata.fraction_detected >= activity_threshold
      [v(j,i), norm_constant_is_negative(j,i)] = mosaik_fcn(stim);
    else
      v(j,i) = 0;
    end
  end
end

if ~isempty(normalization_fcn)
  v = v/normalization_fcn(v);
end

clf(fig, 'reset');

fill_matrix(v);
hold on

concat_colormaps(v, gca, [0 1], @gray, invert_colormap(@autumn), @winter);

[x_neg, y_neg] = find(norm_constant_is_negative);
v_neg = 10*ones(size(x_neg));

h2 = plot3(x_neg, y_neg, v_neg, 'k+', ...
  x_neg, y_neg, v_neg, 'wo', ...
  x_neg, y_neg, v_neg, 'ks', ...
  x_neg, y_neg, v_neg, 'w*');
uistack(h2, 'top');

set(gca, 'YTick', (1:nbr_of_neurons), ...
  'YTickLabel', get_values(neurons, 'file_tag'), ...
  'XTick', (1:nbr_of_stims), ...
  'XTickLabel', stims_str, ...
  'XTickLabelRotation', 270);
axis(gca, 'tight');

end



