function [unique_vals, counts] = count_items_in_list(list, property)

if nargin>1
  list = get_values(list, property);
end

unique_vals = unique(list);

counts = nan(size(unique_vals));

for i=1:length(counts)
  
  counts(i) = nnz(equals(list, get_item(unique_vals,i)));
  
end

[counts, indx] = sort(counts, 'descend');
unique_vals = unique_vals(indx);

end