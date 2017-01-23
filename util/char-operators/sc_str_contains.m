function contains = sc_str_contains(cell_array_str, str)

contains = nnz(sc_str_find(cell_array_str, str));

end