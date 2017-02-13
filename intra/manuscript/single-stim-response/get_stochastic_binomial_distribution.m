function p = get_stochastic_binomial_distribution(nbr_of_positives, probability)

nbr_of_params = max(nbr_of_positives);

if probability == 0
  p = zeros(size(nbr_of_positives));
  p(nbr_of_positives == 0) = 1;
  
elseif probability == 1
  p = zeros(size(nbr_of_positives));
  p(nbr_of_positives == nbr_of_params) = 1;
  
else
  p = probability.^nbr_of_positives .* (1-probability).^(nbr_of_params - nbr_of_positives);
end

end