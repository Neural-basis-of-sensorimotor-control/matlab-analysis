clc
clf

load ..\..\workspace\pairedrecordings

tmp_pair = overlapping_spiketrains(2);

time_sequence = get_values(tmp_pair, @get_touch_pattern_time_sequences);
time_sequence = time_sequence{1};

[n,edges] = histcounts(diff(time_sequence,1,2));
t1 = tmp_pair.neurons(1).get_spiketimes();
t2 = tmp_pair.neurons(2).get_spiketimes();

ind11 = arrayfun(@(x) nnz(time_sequence(:,1) < x), t1);
ind12 = arrayfun(@(x) nnz(time_sequence(:,2) < x), t1);

indx = ind11 - ind12 == 1;
nnz(indx)

nbr_of_spikes_per_seq_1 = get_nbr_of_spikes_per_time_seq(time_sequence, t1);
nbr_of_spikes_per_seq_2 = get_nbr_of_spikes_per_time_seq(time_sequence, t2);

nbr_of_doube_cell_spikes = nnz(nbr_of_spikes_per_seq_1 > 0 & ...
  nbr_of_spikes_per_seq_2 > 0);


max_nbr_of_spikes_per_seq_1 = max(nbr_of_spikes_per_seq_1);
max_nbr_of_spikes_per_seq_2 = max(nbr_of_spikes_per_seq_2);

fprintf('\n       ');
for j=0:max_nbr_of_spikes_per_seq_2
  fprintf('%d          ', j);
end
fprintf('\n');

for i=0:max_nbr_of_spikes_per_seq_1
  fprintf('\n%d  ', i);
  
  nbr_1 = nnz(nbr_of_spikes_per_seq_1 == i);
  
  for j=0:max_nbr_of_spikes_per_seq_2
    nbr_2 = nnz(nbr_of_spikes_per_seq_2 == j);

    fprintf('[%3.d %3.d]  ', nbr_1, nbr_2);
  end
end
fprintf('\n');