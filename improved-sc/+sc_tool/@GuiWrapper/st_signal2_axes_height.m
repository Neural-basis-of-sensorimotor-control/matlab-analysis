function st_signal2_axes_height(obj, str, ~)

axes_height     = obj.axes_height;
axes_height(3)  = str2double(str);
obj.axes_height = axes_height;

end