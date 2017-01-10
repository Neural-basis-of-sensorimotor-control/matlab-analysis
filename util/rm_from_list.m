function list = rm_from_list(list, property, value)

indx = get_list_indx(list, property, value);

list(indx) = [];

end