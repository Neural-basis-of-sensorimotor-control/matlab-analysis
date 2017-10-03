function update_bar(~, active_object_group, x_)

for i=1:length(active_object_group)

  dim = ones(get_nbr_of_samples(active_object_group(i)), 1);
  
  set(active_object_group(i), 'XData', x_ * dim);
  
end

end