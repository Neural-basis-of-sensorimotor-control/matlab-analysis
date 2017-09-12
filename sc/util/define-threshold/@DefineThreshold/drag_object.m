function drag_object(obj, ...
  active_object_type, active_object, active_object_group, active_index)

obj.active_object_type  = active_object_type;
obj.active_object       = active_object;
obj.active_object_group = active_object_group;
obj.active_index        = active_index;

update_background_callbacks(obj)

end