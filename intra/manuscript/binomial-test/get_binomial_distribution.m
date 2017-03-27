function [binomial_distribution, binomial_permutations, nbr_of_positives, ...
  avg_response_rate, shuffled_distribution] = ...
  get_binomial_distribution(neuron, stims_str, response_min, response_max, ...
  normalize)

[binomial_permutations, nbr_of_positives] = get_binomial_permutations(length(stims_str));
binomial_permutations = logical(binomial_permutations);

signal = sc_load_signal(neuron);
templates = get_items(signal.waveforms.list, 'tag', neuron.template_tag);

amplitudes = get_items(signal.amplitudes.list, 'tag', stims_str);

nbr_of_repetitions = min(cell2mat({arrayfun(@(x) length(x.valid_data), amplitudes)}));
response_profiles = false(nbr_of_repetitions, length(amplitudes));

for i=1:nbr_of_repetitions
  
  for j=1:length(amplitudes)
    amplitude = amplitudes(j);
    tmp_triggertime = amplitude.stimtimes(i);
    
    for k=1:length(templates)
      if templates(k).spike_is_detected(tmp_triggertime + response_min, ...
          tmp_triggertime + response_max)
        response_profiles(i, j) = true;
        continue
      end
    end
  end
end

binomial_distribution = get_binomial(response_profiles, binomial_permutations, ...
  normalize);

if nargout>=5
  indx = randperm(numel(response_profiles));
  shuffled_response_profiles = nan(size(response_profiles));
  shuffled_response_profiles(indx) = response_profiles;
  shuffled_distribution = get_binomial(shuffled_response_profiles, ...
    binomial_permutations, normalize);
end

avg_response_rate = mean(response_profiles(:));

end

function binomial_distribution = ...
  get_binomial(response_profiles, binomial_permutations, normalize)

nbr_of_occurences = zeros(size(binomial_permutations,1), 1);

for i=1:length(nbr_of_occurences)
  for j=1:size(response_profiles, 1)
    if all(response_profiles(j,:) == binomial_permutations(i,:))
      nbr_of_occurences(i) = nbr_of_occurences(i) + 1;
    end
  end
end

if normalize
  binomial_distribution = nbr_of_occurences/sum(nbr_of_occurences);
else
  binomial_distribution = nbr_of_occurences;
end

end