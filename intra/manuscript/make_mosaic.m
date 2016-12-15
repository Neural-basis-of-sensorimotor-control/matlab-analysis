%Figure 4
%Create mosaic
%TODO: Add star for negative single pulse!

function make_mosaic
%close all

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

for i=10:length(evaluation_fcns)
  make_mosaic_subfct(evaluation_fcns{i}, normalization_fcns{i}, ...
    apply_thresholds(i), figure(i));
  title(titlestr{i});
end

end


function make_mosaic_subfct(mosaik_fcn, normalization_fcn, apply_threshold, ...
  fig)

neurons = get_intra_neurons();
nbr_of_neurons = length(neurons);
stims_str = get_intra_motifs();
nbr_of_stims = length(stims_str);
v = nan(nbr_of_neurons, nbr_of_stims);
norm_constant_is_negative = false(size(v));

for i=1:nbr_of_neurons
  signal = sc_load_signal(neurons(i));
  activity_threshold = get_threshold(signal);
  
  for j=1:nbr_of_stims
    stim = get_item(signal.amplitudes.cell_list, stims_str{j});
    
    if ~apply_threshold || ...
        stim.userdata.fraction_detected >= activity_threshold
      [v(i,j), norm_constant_is_negative(i,j)] = mosaik_fcn(stim);
    else
      v(i,j) = 0;
    end
  end
end

if ~isempty(normalization_fcn)
  v = v/normalization_fcn(v);
end

[x, y] = meshgrid((1:nbr_of_stims) - .5, (1:nbr_of_neurons) - .5);

clf(fig, 'reset');
h1 = surface(x, y, v);
hold on
concat_colormaps(h1, [0 1], @gray, @autumn, @winter);

vmax = max(v(:));

x_neg = x(norm_constant_is_negative) + .5;
y_neg = y(norm_constant_is_negative) + .5;
v_neg = vmax*ones(size(x_neg)) + 10;

h2 = plot3(x_neg, y_neg, v_neg, 'k+', ...
  x_neg, y_neg, v_neg, 'wo', ...
  x_neg, y_neg, v_neg, 'ks', ...
  x_neg, y_neg, v_neg, 'w*');
uistack(h2, 'top');

set(gca, 'YTick', (1:nbr_of_neurons), ...
  'YTickLabel', get_values(neurons, 'file_str'), ...
  'XTick', (1:nbr_of_stims), ...
  'XTickLabel', stims_str, ...
  'XTickLabelRotation', 270);
axis(gca, 'tight');

end


function [val, neg_normalization] = get_epsp_amplitude_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));
norm_constant = amplitude.parent.userdata.single_pulse_height(ind);

val = mean(amplitude.height) / ...
  abs(norm_constant);

neg_normalization = norm_constant < 0;

end


function [val, neg_normalization] = get_epsp_width_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.width) / ...
  amplitude.parent.userdata.single_pulse_width(ind);

neg_normalization = false;

end


function [val, neg_normalization] = get_onset_latency_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.latency) / ...
  amplitude.parent.userdata.single_pulse_latency(ind);

neg_normalization = false;

end


function [val, neg_normalization] = get_epsp_amplitude_abs(amplitude)

val = mean(amplitude.height);

neg_normalization = false;

end


function [val, neg_normalization] = get_epsp_width_abs(amplitude)

val = mean(amplitude.width);

neg_normalization = false;

end


function [val, neg_normalization] = get_onset_latency_abs(amplitude)

val = mean(amplitude.latency);

neg_normalization = false;

end


function [val, under_threshold] = get_response_fraction(amplitude)

val = amplitude.userdata.fraction_detected;

under_threshold = val < get_threshold(amplitude.parent);

end


function activity_threshold = get_threshold(signal)

activity_threshold = signal.userdata.avg_spont_activity + ...
  3*signal.userdata.std_spont_activity;

end

function v_normalized = normalize_to_max(v)

v_normalized = abs(max(v(:)));

end
