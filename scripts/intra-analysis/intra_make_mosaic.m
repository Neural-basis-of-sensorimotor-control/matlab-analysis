function intra_make_mosaic(neurons, indx, height_limit, min_epsp_nbr, override_colormap, ...
  plot_only_final_figures)

data = {
  @intra_get_epsp_amplitude_single_pulse, 'Amplitude height [single pulse response = 1], ''*'' = negative single pulse',	[], 'concat'	,   1	%1
  @intra_get_epsp_width_single_pulse,	                       'Time to peak [single pulse response = 1]', [],	               'concat'	,   1	%2
  @intra_get_onset_latency_single_pulse,	                   'Latency [single pulse response = 1]', [],	               'concat'	,   1	%3
  @intra_get_epsp_amplitude_abs,	                           'Amplitude height [max value = 1]'	,	   @normalize_to_max, 'concat'	,   1	%4
  @intra_get_epsp_width_abs,	                               'Time to peak [max value = 1]'	,	       @normalize_to_max	,	'concat'	,	1	%5
  @intra_get_onset_latency_abs,	                             'Latency [max value = 1]'	,	           @normalize_to_max	,	'concat'	,	1	%6
  @intra_get_epsp_amplitude_abs,	                           'Amplitude height [absolute value]',    []	,	              'concat'	,	1	%7
  @intra_get_epsp_width_abs,	                               'Time to peak [absolute value]'	,	     []	,	              'concat'	,	1	%8
  @intra_get_onset_latency_abs,	                             'Latency [absolute value]'	,	                                                  []	,	              'concat'	,	1	%9
  @(x) intra_get_response_fraction(x, height_limit, min_epsp_nbr), 'Response fraction ''*'' = below threshold'	,  [], 	'concat'	,	0	%10
  @intra_get_nbr_of_epsps,         	                         '# of EPSPs'	,	                                                                []	,	              'concat'	,	1	%11
  @intra_get_nbr_of_ipsps,	                                 '# of IPSPs'	,	                                                                []	,	              'concat'	,	1	%12
  @intra_get_nbr_of_xpsps,	                                 '# of xPSPs'	,	                                                                []	,	              'concat'	,	1	%13
  @intra_get_epsp_minus_ipsp,	                               '# of EPSPs - # of IPSPs'	,	                                                  []	,	              'concat'	,	1	%14
  @intra_get_epsp_minus_ipsp_only_negative,	                 'EPSPs - IPSPs only negative'	,	                                              []	,	              'concat'	,	1	%15
  @(x) intra_get_epsp_amplitude_single_pulse(x, 'positive'), 'Amplitude height [single pulse response = 1], only EPSPs, ''*'' = negative single pulse'	,	[]	,	'concat'	,	1	%16
  @(x) intra_get_epsp_width_single_pulse(x, 'positive'),	   'Time to peak [single pulse response = 1], only EPSPs', [], 'concat'	,	1	%17
  @(x) intra_get_onset_latency_single_pulse(x, 'positive'),	 'Latency [single pulse response = 1], only EPSPs'	,	[]	,	              'concat'	,	1	%18
  @(x) intra_get_normalized_response_fraction(x, height_limit, min_epsp_nbr), 'Response fraction [spont activity = 1] ''*'' = below threshold'	,	[],        	  'concat'	,	0	%19
  @(x) intra_get_nbr_of_manual_amplitudes(x, height_limit, min_epsp_nbr), 'Number of manual amplitudes ''*'' = below threshold'	,	          [],                 'default'	,	0	%20
  };


evaluation_fcns = data(:,1);

titlestr = data(:,2);

normalization_fcns = data(:,3);

colormap_fcn = data(:,4);

apply_thresholds = cell2mat(data(:,5));

matrices_are_equal(evaluation_fcns, normalization_fcns, titlestr, colormap_fcn, apply_thresholds);

if plot_only_final_figures
  indx = [16 18];
elseif isempty(indx)
  indx = 1:length(apply_thresholds);
end

for i=1:length(indx)
  
  sc_debug.print(mfilename, i, length(indx));
  
  tmp_evaluation_fcn = evaluation_fcns{indx(i)};
  tmp_normalization_fcn = normalization_fcns{indx(i)};
  tmp_apply_thresholds = apply_thresholds(indx(i));
  
  tmp_mosaic_figure = incr_fig_indx();
  
  if plot_only_final_figures
    tmp_lineplot_figure = [];
  else
    tmp_lineplot_figure = incr_fig_indx();
  end
  
  tmp_titlestr = titlestr{indx(i)};
  
  if isempty(override_colormap)
    tmp_colormap_fcn = override_colormap;
  else
    tmp_colormap_fcn = colormap_fcn{indx(i)};
  end
  
  make_mosaic_subfct(neurons, tmp_evaluation_fcn,tmp_normalization_fcn, ...
    tmp_colormap_fcn, tmp_apply_thresholds, height_limit, min_epsp_nbr, ...
    tmp_mosaic_figure, tmp_lineplot_figure);

  figure(tmp_mosaic_figure);
  title([tmp_titlestr ' (mosaic)']);
  
  
  if ~plot_only_final_figures
    figure(tmp_lineplot_figure);
    title([tmp_titlestr ' (line plot)']);
  end
  
end

if plot_only_final_figures
  return
end

stims_str = get_intra_motifs();

incr_fig_indx();
clf('reset')
hold on

for i=1:length(neurons)
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(stims_str)
    
    amplitude = signal.amplitudes.get('tag', stims_str{j});
    
    if amplitude.intra_is_significant_response(height_limit, min_epsp_nbr)
      tag =  'Amplitude response (included)';
    else
      tag = 'Amplitude response (excluded)';
    end
    
    plot(i, amplitude.userdata.fraction_detected, '.', 'Tag', tag);
  end
  
  avg_spont = signal.userdata.avg_spont_activity;
  threshold = get_activity_threshold(signal);
  
  plot(i, avg_spont, '+', 'Tag', 'Spontaneuous activity');
  plot(i, threshold, '+', 'Tag', 'Threshold response');
end

set(gca,'XTick',1:length(neurons),'XTickLabel', {neurons.file_tag}, ...
  'XTickLabelRotation', 270, 'Color', [0 0 0]);
ylabel('Response fraction');
ylim([0 1]);
add_legend(gca);
add_figure_filename(gca);

end


function make_mosaic_subfct(neurons, mosaik_fcn, normalization_fcn, colormap_fcn, ...
  apply_threshold, height_limit, min_epsp_nbr, mosaic_fig, lineplot_fig)

nbr_of_neurons = length(neurons);
stims_str = get_intra_motifs();
nbr_of_stims = length(stims_str);
mosaic = nan(nbr_of_stims, nbr_of_neurons);
norm_constant_is_negative = false(size(mosaic));

for i=1:nbr_of_neurons
  
  sc_debug.print(' ... ', mfilename, 'neuron = ', i, nbr_of_neurons);
  
  signal = sc_load_signal(neurons(i));
  
  for j=1:nbr_of_stims
    stim = get_item(signal.amplitudes.cell_list, stims_str{j});
    
    if ~apply_threshold || ...
        stim.intra_is_significant_response(height_limit, min_epsp_nbr)
      [mosaic(j,i), norm_constant_is_negative(j,i)] = mosaik_fcn(stim);
    else
      mosaic(j,i) = 0;
    end
  end
end

if ~isempty(normalization_fcn)
  mosaic = mosaic/normalization_fcn(mosaic);
end

clf(mosaic_fig, 'reset');

figure(mosaic_fig);

fill_matrix(mosaic);
hold on

[x, y] = find(mosaic == 0);

for i=1:length(x)
  x_ = x(i) + [-.5 -.5 .5 .5 -.5];
  y_ = y(i) + [-.5 .5 .5 -.5 -.5];
  fill(x_, y_, 'w');
end

if isempty(colormap_fcn)
  colormap_fcn = 'default';
end

if ischar(colormap_fcn)
  
  if strcmpi(colormap_fcn, 'default')
     colorbar(gca);
  elseif strcmpi(colormap_fcn, 'concat')
    concat_colormaps(mosaic, gca, [0 1], @gray, invert_colormap(@autumn), @winter);
  elseif strcmpi(colormap_fcn, 'reversed')
    concat_colormaps(mosaic, gca, [0 1], ...
      invert_colormap(@winter), @autumn, invert_colormap(@gray));
  else
    colormap(gca, colormap_fcn);
    colorbar(gca);
  end
  
elseif isnumeric(colormap_fcn)
  
  if length(colormap_fcn)==1
    concat_colormaps(mosaic, gca, colormap_fcn, @gray, invert_colormap(@autumn));
  elseif length(colormap_fcn)==2
    concat_colormaps(mosaic, gca, colormap_fcn, @gray, invert_colormap(@autumn), @winter);
  else
    error('No set of color scales for %d colormaps', length(colormap_fcn));
  end
  
else
  error('Input of type %s disallowed', class(colormap_fcn));
end

[x_neg, y_neg] = find(norm_constant_is_negative);
v_neg = 10*ones(size(x_neg));

h2 = plot3(x_neg, y_neg, v_neg, 'k+', ...
  x_neg, y_neg, v_neg, 'wo', ...
  x_neg, y_neg, v_neg, 'ks', ...
  x_neg, y_neg, v_neg, 'w*');
uistack(h2, 'top');

set(gca, 'YTick', (1:nbr_of_neurons), ...
  'YTickLabel', {neurons.file_tag}, ...
  'XTick', (1:nbr_of_stims), ...
  'XTickLabel', stims_str, ...
  'XTickLabelRotation', 270);
axis(gca, 'tight');

if isempty(lineplot_fig)
  return
end

clf(lineplot_fig, 'reset');

figure(lineplot_fig);

hold on

mosaic(mosaic == 0) = nan;

for j=1:size(mosaic, 2)
  
  plot(1:size(mosaic, 1), mosaic(:, j), 'LineStyle', '-', 'Marker', '+', ...
    'Tag', neurons(j).file_tag);

end

add_legend(lineplot_fig);

end
