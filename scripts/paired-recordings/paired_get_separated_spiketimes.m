function enc_spiketimes = paired_get_separated_spiketimes(neuron, template, ...
  enc_trigger_times, time_range)

dim            = size(enc_trigger_times);
enc_spiketimes = cell(dim);
spiketimes     = paired_get_neuron_spiketime(neuron, template);

for i=1:length(enc_trigger_times)
  
  trigger_times = enc_trigger_times{i};
  enc_spiketimes(i) = {separate_spiketimes(spiketimes, trigger_times, time_range)};
  
end

end

function enc_spiketimes = separate_spiketimes(spiketimes, trigger_times, time_range)

enc_spiketimes = cell(size(trigger_times));

for i=1:length(trigger_times)
  
  tmin          = trigger_times(i) + time_range(1);
  tmax          = trigger_times(i) + time_range(2);
  
  enc_spiketimes(i) = {spiketimes(spiketimes > tmin & spiketimes < tmax) ...
    - trigger_times(i)};
  
end

end