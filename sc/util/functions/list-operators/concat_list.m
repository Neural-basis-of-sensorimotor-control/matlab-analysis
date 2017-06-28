function list1 = concat_list(list1, list2)

for i=1:length(list2)
  list1 = add_to_list(list1, get_item(list2, i));
end

end