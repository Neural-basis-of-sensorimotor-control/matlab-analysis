function score = sc_vpd(spiketimes_1, spiketimes_2, cost)
% score = VPD(spiketimes_1, spiketimes_2, missing_spike_weight, time_dist_weight)
%
% Compute Victor Purpura distance

spiketimes_1 = sort(spiketimes_1);
spiketimes_2 = sort(spiketimes_2);

score = spkd(spiketimes_1, spiketimes_2, cost);

end
