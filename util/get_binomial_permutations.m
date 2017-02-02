function [permutations, nbr_of_positives] = ...
  get_binomial_permutations(nbr_of_values)

permutations = nan(2^nbr_of_values, nbr_of_values);
count = 0;

for i=0:nbr_of_values
  
  values = zeros(1, nbr_of_values);
  values(1:i) = 1;
  tmp_permutations = unique(perms(values), 'rows');
  
  nbr_of_permutations = size(tmp_permutations, 1);
  row_indx = count + (1:nbr_of_permutations);
  
  permutations(row_indx,:) = tmp_permutations;
  
  count = count + nbr_of_permutations;
end

nbr_of_positives = sum(permutations, 2);