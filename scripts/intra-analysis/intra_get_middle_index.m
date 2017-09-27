function indx_logical = intra_get_middle_index(rise, remove_fraction)

n = length(rise);
[~, indx] = sort(rise);
indx_logical = true(size(indx));
bottom_percentile = 1:round(n*remove_fraction);
top_percentile = round(n*(1-remove_fraction)):n;
indx_logical(indx(bottom_percentile)) = false(size(bottom_percentile));
indx_logical(indx(top_percentile)) = false(size(top_percentile));

end