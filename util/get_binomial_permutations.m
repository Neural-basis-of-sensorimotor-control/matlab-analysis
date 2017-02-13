function [permutations, nbr_of_positives] = ...
  get_binomial_permutations(nbr_of_values)


x = dec2bin(0:2^nbr_of_values-1);
permutations = nan(size(x));

for i=1:size(x,1)
  for j=1:size(x,2)
    permutations(i,j) = str2double(x(i,j));
  end
end

nbr_of_positives = sum(permutations, 2);

