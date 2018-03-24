function st_signal1_axes_height(obj, str, ~)

axes_height     = obj.axes_height;
axes_height(2)  = str2double(str);
obj.axes_height = axes_height;

end