function t_back = get_t_back(spiketimes_1, spiketimes_2)

spiketimes_2 = sort(spiketimes_2);

t_back = arrayfun(@(x) get_time_to_previous(x, spiketimes_2), ...
  spiketimes_1);
t_back = t_back(isfinite(t_back));

end

function t = get_time_to_previous(time1, all_other_times)

ind = find(all_other_times < time1, 1, 'last');

if isempty(ind)
  t = inf;
else
  t = all_other_times(ind) - time1;
end

end