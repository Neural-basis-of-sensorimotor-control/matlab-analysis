function t_forward = get_t_forward(spiketimes_1, spiketimes_2)

spiketimes_2 = sort(spiketimes_2);

t_forward = arrayfun(@(x) get_time_to_next(x, spiketimes_2), ...
  spiketimes_1);
t_forward = t_forward(isfinite(t_forward));

end

function t = get_time_to_next(time1, all_other_times)

ind = find(all_other_times > time1, 1);

if isempty(ind)
  t = inf;
else
  t = all_other_times(ind) - time1;
end

end