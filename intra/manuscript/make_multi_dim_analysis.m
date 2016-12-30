function make_multi_dim_analysis(varargin)
% % %Make multidimensional analysis
% % % Figure 5
clc
close all

scaling_dim = 2;
neurons = get_intra_neurons();
stims = get_intra_motifs();
exclude_neurons = {};

for i=1:2:length(varargin)
  switch varargin{i}
    case '-scaling_dim'
      scaling_dim = varargin{i+1};
    case '-exclude'
      exclude_neurons = varargin{i+1};
    otherwise
      error('Invalid input: %s', varargin{i});
  end
end

neurons = rm_from_list(neurons, 'file_str', exclude_neurons);

is_responses = generate_response_matrix(neurons, stims);
% stims = stims(all(is_responses, 2));
% is_responses = generate_response_matrix(neurons, stims);

evaluation_fcns = {@get_epsp_amplitude_single_pulse
  @get_epsp_width_single_pulse
  @get_onset_latency_single_pulse
  @get_epsp_amplitude_abs
  @get_epsp_width_abs
  @get_onset_latency_abs
  };

titlestrs = {'Amplitude height [single pulse response = 1]'
  'Time to peak [single pulse response = 1]'
  'Latency [single pulse response = 1]'
  'Amplitude height [max value = 1]'
  'Time to peak [max value = 1]'
  'Latency [max value = 1]'};

normalization_fcns = {[]
  []
  []
  @normalize_to_max
  @normalize_to_max
  @normalize_to_max
  };

evaluation_fcns_2 = {...
  {@get_epsp_amplitude_single_pulse,  @get_epsp_width_single_pulse}
  {@get_epsp_amplitude_single_pulse,  @get_onset_latency_single_pulse}
  {@get_onset_latency_single_pulse,  @get_epsp_width_single_pulse}};

titlestrs_2 = {{'Amplitude height [single pulse response = 1]', 'Time to peak [single pulse response = 1]'}
  {'Amplitude height [single pulse response = 1]', 'Latency [single pulse response = 1]'}
  {'Latency [single pulse response = 1]', 'Time to peak [single pulse response = 1]'}};

normalization_fcns_2 = {{[], []}, {[], []}, {[], []}};


evaluation_fcns_3 = {...
  {@get_epsp_amplitude_single_pulse,  @get_epsp_width_single_pulse, ...
  @get_onset_latency_single_pulse}};

titlestrs_3 = {{'Amplitude height [single pulse response = 1]', 'Time to peak [single pulse response = 1]', ...
  'Latency [single pulse response = 1]'}};

normalization_fcns_3 = {{[], [], []}};

for i1=1:length(evaluation_fcns)
  fprintf('%d (%d)\n', i1, length(evaluation_fcns));
  
  fig = figure(i1);
  try
    make_mds(fig, evaluation_fcns{i1}, normalization_fcns{i1}, titlestrs{i1})
  catch exception
    msgbox('Exception caught');
    assignin('base', 'exception',exception);
  end
end

for i2=1:length(evaluation_fcns_2)
  fprintf('%d (%d)\n', i2, length(evaluation_fcns_2));
  
  fig = figure(i1+i2);
  make_mds_2(fig, evaluation_fcns_2{i2}, normalization_fcns_2{i2}, titlestrs_2{i2});
end

for i3=1:length(evaluation_fcns_3)
  fprintf('%d (%d)\n', i3, length(evaluation_fcns_3));
  
  fig = figure(i2+i3);
  make_mds_3(fig, evaluation_fcns_3{i3}, normalization_fcns_3{i3}, titlestrs_3{i3});
end


  function make_mds(fig, evaluation_fcn, normalization_fcn, titlestr)
    
    response_values = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcn);
    
    figure(fig);
    fig.FileName = ['MDS_' titlestr '.png'];
    subplot(2,2, [1 2])
    title(titlestr);
    response_values(~is_responses) = 0;
    
    if ~isempty(normalization_fcn)
      response_values = normalization_fcn(response_values);
    end
    
    fill_matrix(response_values);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %    concat_colormaps(response_values, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %      @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    d = pdist(response_values');
    y = mdscale(d, scaling_dim);
    
    subplot(223)
    plot_mda(y, neurons);
    title('Non-linear MDS');
    
    y = cmdscale(d, scaling_dim);
    
    subplot(224)
    plot_mda(y, neurons);
    title('Classical MDS');
    add_legend([subplot(223) subplot(224)]);
    
  end

  function make_mds_2(fig, evaluation_fcns, normalization_fcn, titlestrs)
    
    response_values1 = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcns{1});
    response_values1(~is_responses) = 0;
    
    if ~isempty(normalization_fcn{1})
      response_values1 = normalization_fcn(response_values1);
    end
    
    response_values2 = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcns{2});
    response_values2(~is_responses) = 0;
    
    if ~isempty(normalization_fcn{2})
      response_values2 = normalization_fcn(response_values2);
    end
    
    figure(fig);
    fig.FileName = ['MDS_' titlestrs{1} '_' titlestrs{2} '.png'];
    
    subplot(221)
    title(titlestrs{1})
    
    fill_matrix(response_values1);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %     concat_colormaps(response_values1, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %       @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    subplot(222)
    title(titlestrs{2})
    fill_matrix(response_values2);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %     concat_colormaps(response_values2, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %       @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    d = pdist([response_values1' response_values2']);
    y = mdscale(d, scaling_dim);
    
    subplot(223)
    plot_mda(y, neurons);
    title('Non-linear MDS');
    
    y = cmdscale(d, scaling_dim);
    
    subplot(224)
    plot_mda(y, repmat(neurons, 1, 2));
    title('Classical MDS');
    add_legend([subplot(223) subplot(224)]);
    
  end

  function make_mds_3(fig, evaluation_fcns, normalization_fcn, titlestrs)
    
    response_values1 = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcns{1});
    response_values1(~is_responses) = 0;
    
    if ~isempty(normalization_fcn{1})
      response_values1 = normalization_fcn(response_values1);
    end
    
    response_values2 = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcns{2});
    response_values2(~is_responses) = 0;
    
    if ~isempty(normalization_fcn{2})
      response_values2 = normalization_fcn(response_values2);
    end
    
    response_values3 = generate_response_value_matrix(neurons, stims, ...
      evaluation_fcns{3});
    response_values3(~is_responses) = 0;
    
    if ~isempty(normalization_fcn{3})
      response_values3 = normalization_fcn(response_values3);
    end
    
    figure(fig);
    fig.FileName = ['MDS_' titlestrs{1} '_' titlestrs{2} '_' titlestrs{3} '.png'];
    subplot(231)
    title(titlestrs{1})
    
    fill_matrix(response_values1);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %     concat_colormaps(response_values1, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %       @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    subplot(232)
    title(titlestrs{2})
    fill_matrix(response_values2);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %     concat_colormaps(response_values2, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %       @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    
    subplot(233)
    title(titlestrs{3})
    fill_matrix(response_values3);
    hold on
    [x,y] = find(~is_responses);
    add_square(x, y, 'w');
    %     concat_colormaps(response_values3, gca, 0, @(x) invert_colormap(@autumn, x), ...
    %       @winter)
    colorbar
    setup_intra_axes(neurons, stims);
    
    d = pdist([response_values1' response_values2' response_values3']);
    y = mdscale(d, scaling_dim);
    
    
    subplot(234)
    plot_mda(y, neurons);
    title('Non-linear MDS');
    
    y = cmdscale(d, scaling_dim);
    
    subplot(235)
    plot_mda(y, neurons);
    title('Classical MDS');
    add_legend([subplot(234) subplot(235)]);
    
  end

end
