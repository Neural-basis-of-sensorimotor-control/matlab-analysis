function val = get_nbr_of_spikes_per_time_seq(time_seq, spiketimes)


val = arrayfun(@(x,y) nnz(spiketimes > x) - nnz(spiketimes > y), ...
  time_seq(:,1), time_seq(:,2));


end