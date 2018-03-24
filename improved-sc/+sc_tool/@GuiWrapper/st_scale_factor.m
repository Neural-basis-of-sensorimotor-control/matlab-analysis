function st_scale_factor(obj, str, ~)

obj.signal1.filter.scale_factor = str2double(str);
obj.has_unsaved_changes = true;
obj.signal1 = obj.signal1;
obj.update_plots();

end