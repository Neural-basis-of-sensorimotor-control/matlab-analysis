function d = compute_euclidian_distances(values)

d = nan(size(values,2));

for i=1:size(values,2)
  fprintf('%d (%d)\n', i, size(values,2));
  for j=1:size(values,2)
    if i==j
      d(i,j) = 0;
    else
      n1 = values(:,i);
      n2 = values(:,j);
      
      d(i,j) = sqrt(sum((n2-n1).^2));
    end
  end
end

