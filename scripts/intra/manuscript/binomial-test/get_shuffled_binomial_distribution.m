function shuffled_dist = get_shuffled_binomial_distribution(binomial_permutations, ...
  response_profiles, normalize)

indx = randperm(numel(response_profiles));
shuffled_response_profiles = nan(size(response_profiles));
shuffled_response_profiles(indx) = response_profiles;
shuffled_dist = get_binomial(shuffled_response_profiles, ...
  binomial_permutations, normalize);

end


