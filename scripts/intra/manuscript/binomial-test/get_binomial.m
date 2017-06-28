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