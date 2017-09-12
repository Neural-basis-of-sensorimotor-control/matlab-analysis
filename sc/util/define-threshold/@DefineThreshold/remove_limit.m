function remove_limit(obj, indx)

obj.x(indx)       = [];
obj.y_lower(indx) = [];
obj.y_upper(indx) = [];

obj.has_unsaved_changes = true;

plot_starting_point(obj, obj.x0, obj.y0);

end
