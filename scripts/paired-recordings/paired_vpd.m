function result = paired_vpd(neuron, cost, time_range)

if length(neuron) ~= 1
  
  result = vectorize_fcn(@paired_vpd, neuron, cost, time_range);
  
  return
  
end

[enc_trigger_times, str_pattern] = paired_get_pattern_times(neuron);

enc_t1 = paired_get_separated_spiketimes(neuron, 1, enc_trigger_times, time_range);
enc_t2 = paired_get_separated_spiketimes(neuron, 2, enc_trigger_times, time_range);

enc_t1_rep_shuffled    = shuffle_time(enc_t1);
enc_t1_all_shuffled = shuffle_all(enc_t1);

enc_t2_rep_shuffled    = shuffle_time(enc_t2);
enc_t2_all_shuffled = shuffle_all(enc_t2);

normal_score                   = paired_get_vpd_score(enc_t1, enc_t2, cost);

rep_shuffled_score            = paired_get_vpd_score(enc_t1_rep_shuffled, enc_t2, cost);

all_shuffled_score         = paired_get_vpd_score(enc_t1_all_shuffled, enc_t2, cost);

self_t1_rep_shuffled_score    = paired_get_vpd_score(enc_t1_rep_shuffled, enc_t1, cost);

self_t1_all_shuffled_score = paired_get_vpd_score(enc_t1_all_shuffled, enc_t1, cost);

self_t2_rep_shuffled_score    = paired_get_vpd_score(enc_t2_rep_shuffled, enc_t2, cost);

self_t2_all_shuffled_score = paired_get_vpd_score(enc_t2_all_shuffled, enc_t2, cost);

incr_fig_indx();
clf;
hold on

for i=1:length(normal_score)
  
  plot(mean(normal_score{i}),               1, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(rep_shuffled_score{i}),         2, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(all_shuffled_score{i}),         3, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(self_t1_rep_shuffled_score{i}), 4, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(self_t2_rep_shuffled_score{i}), 5, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(self_t1_all_shuffled_score{i}), 6, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  plot(mean(self_t2_all_shuffled_score{i}), 7, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2);
  
end

set(gca, 'YDir', 'reverse', 'YTick', 1:7, 'YTickLabel', ...
  {'normal score', 'repetition shuffled', 'all shuffled', ...
  'self 1 repetition shuffled', 'self 2 repetition shuffled', ...
  'self 1 all shuffled', 'self 2 all shuffled'})

ylim([0 8])

result.normal               = mean(cell2mat(sc_unpack_cell(normal_score)));
result.rep_shuffled         = mean(cell2mat(sc_unpack_cell(rep_shuffled_score)));
result.all_shuffled         = mean(cell2mat(sc_unpack_cell(all_shuffled_score)));
result.self_t1_rep_shuffled = mean(cell2mat(sc_unpack_cell(self_t1_rep_shuffled_score)));
result.self_t2_rep_shuffled = mean(cell2mat(sc_unpack_cell(self_t2_rep_shuffled_score)));
result.self_t1_all_shuffled = mean(cell2mat(sc_unpack_cell(self_t1_rep_shuffled_score)));
result.self_t2_all_shuffled = mean(cell2mat(sc_unpack_cell(self_t2_rep_shuffled_score)));

end


function t_shuffled = shuffle_time(t)

t_shuffled = cell(size(t));

for i=1:length(t)
  
  tmp_t = t{i};
  indx  =  randperm(length(tmp_t));
  t_shuffled(i) = {tmp_t(indx)};
  
end

end

function t_shuffled = shuffle_all(t)

values     = sc_unpack_cell(t);
indx       = randperm(length(values));

t_shuffled = cell(size(t));
count      = 0;

for i=1:length(t)
  
  tmp_n         = length(t{i});
  t_shuffled(i) = {values(indx(count + (1:tmp_n)))};
  count         = count + tmp_n;
  
end

end