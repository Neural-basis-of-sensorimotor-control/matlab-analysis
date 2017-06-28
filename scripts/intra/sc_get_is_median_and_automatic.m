function median_all = sc_get_is_median_and_automatic(obj, remove_fraction)

median_all = true(size(obj.rise));
median_all(~obj.automatic_xpsp_detected) = false;

[~, indx_automatic] = sort(obj.rise(obj.automatic_xpsp_detected));
median_automatic = true(size(indx_automatic));

n = length(indx_automatic);

if ~n
	return
end

bottom_percentile = 1:round(n*remove_fraction);
top_percentile = round(n*(1-remove_fraction)):n;
median_automatic(indx_automatic(bottom_percentile)) = false(size(bottom_percentile));
median_automatic(indx_automatic(top_percentile)) = false(size(top_percentile));

median_all(obj.automatic_xpsp_detected) = median_automatic;

end