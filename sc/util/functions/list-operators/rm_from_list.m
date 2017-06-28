function list = rm_from_list(list, varargin)

indx = get_list_indx(list, varargin{:});

list(indx) = [];

end