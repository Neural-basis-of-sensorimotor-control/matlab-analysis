function st_smoothing_width(obj, str, ~)

obj.signal1.filter.smoothing_width = str2double(str);
obj.has_unsaved_changes = true;
obj.signal1 = obj.signal1;
obj.update_plots();

end