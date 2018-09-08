clear
close all
hold on

load paired_statistical.mat

% for i=1:size(dist_neuron_to_multinomial_response, 2)
%   
%   x_1 = dist_neuron_to_multinomial_response(:, i);
%   
%   plot(x_1, 1:length(x_1), 'Tag', neurons(i).file_tag, 'Marker', 'o');
%   
%   x_2 = dist_shuffled_to_multinomial_response_several_simulations_1(:, i);
%   
%   plot(x_2, 1:length(x_1), 'Tag', neurons(i).file_tag, 'Marker', '^', 'LineStyle', '--');
%   
% end

for i=1:size(dist_neuron_to_multinomial_response, 1)
  
  sc_square_subplot(size(dist_neuron_to_multinomial_response, 1), i);
  hold on
  
  x_1 = dist_neuron_to_multinomial_response(i, :);
  
  plot(x_1, 1:length(x_1), 'Marker', 'o', 'Tag', 'Measured');
  
  x_2 = dist_shuffled_to_multinomial_response_several_simulations_1(i, :);
  
  tmp_p1 = signrank(x_1 - x_2);
  %[~, tmp_p2] = ttest(x_1, x_2);
  fprintf('P = %f\n', tmp_p1);
  
  plot(x_2, 1:length(x_1), 'Marker', '^', 'LineStyle', '--', 'Tag', 'Simulated');
  
  %title([stim_pulses(i).pattern ' (' stim_pulses(i).electrode '), N = ' num2str(stim_pulses(i).electrode_count)])
  title(sprintf('Pattern %d (%d electrodes), P = %f, %f', i, stim_pulses(i).electrode_count, tmp_p1));%, tmp_p2));
  
  grid on
  
  set(gca, 'YTick', 1:length(neurons), 'YTickLabel', ...
    arrayfun(@(x) sprintf('%d', x), 1:length(neurons), 'UniformOutput', false));
  
  ylabel('Neuron');
  
  xl = xlim;
  xlim([0 xl(2)])


  
  
end

add_legend(gcf, true);
return
% incr_fig_indx()
% clf
% hold on
% 
% p = 0.05;
% 
% for i=1:size(avg_response_repeated_simulations_1, 1)
%   
%   xs         = mean(avg_response_repeated_simulations_1(i, :));
%   std_xs     = std(avg_response_repeated_simulations_1(i, :), 1);
%   alpha      = tinv(1 - p, length(neurons)-1);
%   conf_bound = alpha*std_xs/(sqrt(length(neurons)));
%   
%   plot(xs, i, 'k+', xs - conf_bound, i, 'k+', xs + conf_bound, i, 'k+', ...
%     xs + conf_bound*[-1 1], i*[1 1], 'k');
%   
% end
% 
% ylim([0 i+1])
% set(gca, 'YTick', 1:i, ...
%   'YTickLabel', arrayfun(@(x, y) sprintf('Pattern %d (%d pulses)', x, y.electrode_count), 1:i, stim_pulses, 'UniformOutput', false));
% 
% grid on
% xlabel('ln [x_m_e_a_s_u_r_e_d - x_i_d_e_a_l] - ln [x_s_i_m_u_l_a_t_e_d]')
% 
% return


clear
close all
reset_fig_indx()
sc_settings.set_current_settings_tag(sc_settings.tags.INTRA);

intra_load_constants
stims = get_intra_motifs();
stim_pulses = intra_get_multiple_stim_pulses(stims);
normalize_distributions = true;


% nbr_of_manual_amplitudes = 0;
% tot_nbr_of_amplitudes    = 0;
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
% 
%   for j=1:length(stims)
% 
%     amplitude = signal.amplitudes.get('tag', stims{j});
%     nbr_of_manual_amplitudes = nbr_of_manual_amplitudes + nnz(amplitude.valid_data);
%     tot_nbr_of_amplitudes = tot_nbr_of_amplitudes + length(amplitude.valid_data);
% 
%   end
% end
% 
% nbr_of_manual_amplitudes
% tot_nbr_of_amplitudes
% 
% single_pulses = {'1p electrode 1'
%   '1p electrode 2'
%   '1p electrode 3'
%   '1p electrode 4'};
% 
% nbr_of_manual_stim_amplitudes = 0;
% tot_nbr_of_stim_amplitudes    = 0;
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
% 
%   for j=1:length(single_pulses)
% 
%     for k=1:4
% 
%       for m=1:100
% 
%         stim_str = [single_pulses{j} '#V' num2str(k) '#' num2str(m)];
%         amplitude = signal.amplitudes.get('tag', stim_str);
% 
%         if isempty(amplitude)
%           continue;
%         end
% 
%         nbr_of_manual_stim_amplitudes = nbr_of_manual_stim_amplitudes + nnz(amplitude.valid_data);
%         tot_nbr_of_stim_amplitudes = tot_nbr_of_stim_amplitudes + length(amplitude.valid_data);
% 
%       end
% 
%     end
% 
%   end
% 
% end
% 
% nbr_of_manual_stim_amplitudes
% tot_nbr_of_stim_amplitudes
% 
% %%
% total_time = 0;
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
%   total_time = total_time + signal.N * signal.dt;
% 
% end
% 
% total_time
% total_time/60
% total_time/3600
% 
% manual_automatic         = 0;
% manual_not_automatic     = 0;
% not_manual_automatic     = 0;
% not_manual_not_automatic = 0;
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
% 
%   for j=1:length(stims)
% 
%     amplitude = signal.amplitudes.get('tag', stims{j});
% 
%     tmp_automatic = amplitude.userdata.fraction_detected >= intra_get_activity_threshold(signal);
%     tmp_manual    = amplitude.intra_is_significant_response(height_limit, ...
%       min_nbr_epsp);
% 
%     if tmp_manual && tmp_automatic
%       manual_automatic = manual_automatic + 1;
%     elseif tmp_manual
%       manual_not_automatic = manual_not_automatic + 1;
%     elseif tmp_automatic
%       not_manual_automatic = not_manual_automatic + 1;
%     else
%       not_manual_not_automatic = not_manual_not_automatic + 1;
%     end
% 
%   end
% 
% end
% 
% manual_automatic
% manual_not_automatic
% not_manual_automatic
% not_manual_not_automatic
% 
% 
% nbr_of_repetitions = [];
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
% 
%   amplitude = signal.amplitudes.get('tag', stims{1});
%   nbr_of_repetitions = add_to_list(nbr_of_repetitions, length(amplitude.stimtimes));
% 
% end
% 
% [values, count] = count_items_in_list(nbr_of_repetitions)
% 
% nbr_of_detections_manual_automatic         = [];
% nbr_of_detections_manual_not_automatic     = [];
% nbr_of_detections_not_manual_automatic     = [];
% nbr_of_detections_not_manual_not_automatic = [];
% 
% for i=1:length(neurons)
% 
%   sc_debug.print(i, length(neurons))
% 
%   signal = sc_load_signal(neurons(i));
% 
%   for j=1:length(stims)
% 
%     amplitude = signal.amplitudes.get('tag', stims{j});
% 
%     tmp_automatic    = amplitude.userdata.fraction_detected >= intra_get_activity_threshold(signal);
%     [~, nbr_of_manual_responses] = amplitude.intra_is_significant_response(height_limit, ...
%       min_nbr_epsp);
% 
%     tmp_manual = nbr_of_manual_responses > min_nbr_epsp;
% 
%     if tmp_manual && tmp_automatic
%       nbr_of_detections_manual_automatic          = add_to_list(nbr_of_detections_manual_automatic, nbr_of_manual_responses);
%     elseif tmp_manual
%       nbr_of_detections_manual_not_automatic     = add_to_list(nbr_of_detections_manual_not_automatic, nbr_of_manual_responses);
%     elseif tmp_automatic
%       nbr_of_detections_not_manual_automatic     = add_to_list(nbr_of_detections_not_manual_automatic, nbr_of_manual_responses);
%     else
%       nbr_of_detections_not_manual_not_automatic = add_to_list(nbr_of_detections_not_manual_not_automatic, nbr_of_manual_responses);
%     end
% 
%   end
% 
% end
% 
% incr_fig_indx()
% clf
% hold on
% plot(nbr_of_detections_manual_automatic,           ones(size(nbr_of_detections_manual_automatic)),      ...
%   'LineStyle', 'none', 'Marker', '+', 'Tag', sprintf('Manual + automatic (N = %d)', length(nbr_of_detections_manual_automatic)));
% plot(nbr_of_detections_manual_not_automatic,     2*ones(size(nbr_of_detections_manual_not_automatic)),  ...
%   'LineStyle', 'none', 'Marker', '+', 'Tag', sprintf('Manual (N = %d)', length(nbr_of_detections_manual_not_automatic)));
% plot(nbr_of_detections_not_manual_automatic,     3*ones(size(nbr_of_detections_not_manual_automatic)),  ...
%   'LineStyle', 'none', 'Marker', '+', 'Tag', sprintf('Aautomatic (N = %d)', length(nbr_of_detections_not_manual_automatic)));
% plot(nbr_of_detections_not_manual_not_automatic, 4*ones(size(nbr_of_detections_not_manual_not_automatic)), ...
%   'LineStyle', 'none', 'Marker', '+', 'Tag', sprintf('Neither (N = %d)', length(nbr_of_detections_not_manual_not_automatic)));
% add_legend
% ylim([0 5])
% 
% 
values = cell(length(stims), length(neurons));

for i_neuron=1:length(neurons)
  i_neuron
  sc_debug.print(i_neuron, length(neurons))

  signal = sc_load_signal(neurons(i_neuron));

  for i_stim=1:length(stims)

    amplitude = signal.amplitudes.get('tag', stims{i_stim});

    is_response = amplitude.intra_is_significant_response(height_limit, ...
      min_nbr_epsp);

    if is_response

      x = amplitude.get_amplitude_height(height_limit) / ...
        intra_get_epsp_amplitude_single_pulse(amplitude, height_limit);

      values(i_stim, i_neuron) = {x};

    end

  end

end
% 
% pval = .05;
% 
% for i_neuron=1:length(neurons)
% 
%   incr_fig_indx();
%   clf
%   hold on
%   grid on
%   ylim([0 53])
% 
%   for i_stim=1:length(stims)
% 
%     x = values{i_stim, i_neuron};
% 
%     alpha   = tinv(1-pval, length(x)-1);
% 
%     meanval = mean(x);
%     stddev  = std(x, 1);
%     minval = meanval - alpha*stddev;
%     maxval = meanval + alpha*stddev;
% 
%     plot(x, i_stim*ones(size(x)), '.')
%     plot(meanval, i_stim+.2, 'ko');
%     plot(minval,  i_stim+.2, 'k+');
%     plot(maxval, i_stim+.2,  'k+');
%     plot([minval maxval], i_stim*[1 1]+.2, 'k');
% 
%   end
% 
% end

% for i_fig=1:length(stims)
%   i_fig
% 
%   p = zeros(length(neurons));
% 
%   for i_neuron1=1:length(neurons)
% 
%     if ~isempty(values{i_fig, i_neuron1})
% 
%       for i_neuron2=i_neuron1+1:length(neurons)
% 
%         if ~isempty(values{i_fig, i_neuron2})
% 
%           p(i_neuron1, i_neuron2) = ranksum(values{i_fig, i_neuron1}, values{i_fig, i_neuron2});
% 
%         end
%       end
%     end
%   end
% 
%   incr_fig_indx
%   clf
%   fill_matrix(p);
%   hold on
% 
%   [x, y] = find(p == 0);
% 
%   for i=1:length(x)
% 
%     x_ = x(i) + [-.5 -.5 .5 .5 -.5];
%     y_ = y(i) + [-.5 .5 .5 -.5 -.5];
%     fill(x_, y_, 'w');
% 
%   end
% 
%   colorbar
%   set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
%     'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_tag}, 'XTickLabelRotation', 270);
%   title(stims{i_fig}, 'Interpreter', 'None');
%   axis tight
% 
% end

for i_neuron=1:length(neurons)
  i_neuron

  p = zeros(length(stims));

  for i_stim1=1:length(stims)

    if ~isempty(values{i_stim1, i_neuron})

      for i_stim2=i_stim1+1:length(stims)

        if ~isempty(values{i_stim2, i_neuron})

          x1 = values{i_stim1, i_neuron};
          x2 = values{i_stim2, i_neuron};

          x1_tags = cellfun(@(~) 'a', cell(size(x1)) );
          x2_tags = cellfun(@(~) 'b', cell(size(x2)) );
          tags  = [x1_tags; x2_tags];
          m     = [x1; x2];

          p(i_stim1, i_stim2) = ranksum(x1, x2);%anova1(m, tags, 'off');%

        end
      end
    end
  end

  pos = any(p, 1)' | any(p, 2);

  p = p(pos, pos);

  tmp_stims = stims(pos);

  incr_fig_indx
  clf
  fill_matrix(p);
  hold on

  [x, y] = find(p == 0);

  for i=1:length(x)

    x_ = x(i) + [-.5 -.5 .5 .5 -.5];
    y_ = y(i) + [-.5 .5 .5 -.5 -.5];
    fill(x_, y_, 'w');

  end

  colorbar
  set(gca, 'XTick', 1:length(tmp_stims), 'XTickLabel', tmp_stims, 'YDir', 'reverse', ...
    'YTick', 1:length(tmp_stims), 'YTickLabel', tmp_stims, 'XTickLabelRotation', 270, ...
    'XAxisLocation', 'top');
  title(neurons(i_neuron).file_tag, 'Interpreter', 'None');
  axis tight

end

mxfigs
brwfigs

return
indx_neuron = 1;
indx_stim_pulses = 1;

neuron = neurons(indx_neuron);

pattern_str = stim_pulses(indx_stim_pulses).pattern;
electrode_str = stim_pulses(indx_stim_pulses).electrode;
tmp_stims = get_items(stims, @get_pattern, pattern_str);
tmp_stims = get_items(tmp_stims, @get_electrode, electrode_str);

[neuron_distribution, stat_distribution_avg_response, shuffled_distribution_1, ...
  binomial_permutations, ~, response_profiles] ...
  = compute_binomial_distribution(neuron, tmp_stims, response_min, ...
  response_max, normalize_distributions);

[~, ~, shuffled_distribution_2] ...
  = compute_binomial_distribution(neuron, tmp_stims, response_min, ...
  response_max, normalize_distributions);

[~, ~, shuffled_distribution_3] ...
  = compute_binomial_distribution(neuron, tmp_stims, response_min, ...
  response_max, normalize_distributions);

str_binomial_distribution = cell(size(binomial_permutations, 1), 1);

for i=1:size(binomial_permutations, 1)
  
  str = num2str(binomial_permutations(i, :));
  str = str(str ~= ' ');
  str = ['''' str ''''];
  
  str_binomial_distribution(i) = {str};

end

incr_fig_indx();
clf
hold on
bar([neuron_distribution stat_distribution_avg_response shuffled_distribution_1]);% shuffled_distribution_2 shuffled_distribution_3])
legend({'Measured distribution', 'Multinomial distribution', 'Multinomial distribution + simulated sampling error'}, 'FontName', 'Arial')

yticks = get(gca, 'YTick');
pos = arrayfun(@(x) mod(x, .1) == 0, yticks);
yticks = yticks(pos);

set(gca, 'FontSize', 20);
set(gca, 'XTick', 1:length(neuron_distribution), 'XTickLabel', ...
  str_binomial_distribution, 'YTick', yticks, 'FontName', 'Arial');

set(gcf, 'Color', [1 1 1])

xlabel('Response', 'FontName', 'Arial')
ylabel('Relative distribution', 'FontName', 'Arial')

incr_fig_indx();
clf

subplot(2, 2, 1)
bar(neuron_distribution)
setup_axes(str_binomial_distribution)
title('Measured distribution', 'FontWeight', 'normal', 'FontName', 'Arial')

subplot(2, 2, 2)
bar(stat_distribution_avg_response)
setup_axes(str_binomial_distribution)
title('Multinomial distribution', 'FontWeight', 'normal', 'FontName', 'Arial')

subplot(2, 2, 3)
bar(shuffled_distribution_1)
setup_axes(str_binomial_distribution)
title('Multinomial distribution + simulated sampling error 1 (10 000)', 'FontWeight', 'normal', 'FontName', 'Arial')

subplot(2, 2, 4)
bar(shuffled_distribution_1)
setup_axes(str_binomial_distribution)
title('Multinomial distribution + simulated sampling error 2 (10 000)', 'FontWeight', 'normal', 'FontName', 'Arial')

linkaxes(get_axes(gcf))
xlim([0 length(str_binomial_distribution)+1])

set(gcf, 'Color', [1 1 1]);

function setup_axes(str_binomial_distribution)

set(gca, 'FontSize', 16);

set(gca, 'XTick', 1:length(str_binomial_distribution), 'XTickLabel', str_binomial_distribution, ...
  'Box', 'off', 'FontName', 'Arial');

%xlabel('Response')
%ylabel('Relative distribution')

end