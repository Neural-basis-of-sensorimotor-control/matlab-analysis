function st_trigger_axes_height(obj, str, ~)

axes_height     = obj.axes_height;
axes_height(1)  = str2double(str);
obj.axes_height = axes_height;

end