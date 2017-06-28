function obj = update_class(a)

class_str = class(a);

eval(['obj = ' class_str '.loadobj(a);'])

end