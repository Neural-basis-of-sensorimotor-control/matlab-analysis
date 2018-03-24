function st_artifact_width(obj, str, ~)

obj.signal1.filter.artifact_width = str2double(str);
obj.has_unsaved_changes = true;
obj.signal1 = obj.signal1;
obj.update_plots();

end