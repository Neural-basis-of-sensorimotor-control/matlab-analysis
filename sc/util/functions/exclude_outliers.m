function y = exclude_outliers(x, outlier_fraction)

if isempty(x)
  y = x;
  return
end

[~, order_ind] = sort(x, 2);
outlier_width  = floor(outlier_fraction * size(x, 2));

pos = order_ind >= outlier_width & order_ind <= (size(x, 2) - outlier_width);

y = nan(size(x, 1), nnz(pos)/size(x, 1));

for i=1:size(x, 1)
  y(i, :) = x(i, pos(i, :));
end

end