function new_child = get_new_child(parent, old_child)

default_ind = 1;

if isempty(parent)
  new_child = [];
elseif ~parent.n
  new_child = [];
elseif isa(parent, 'ScList')
  new_child = get_set_val(parent.list, old_child, default_ind);
elseif isa(parent, 'ScCellList')
  new_child = get_set_val(parent.cell_list, old_child, default_ind);
end

end