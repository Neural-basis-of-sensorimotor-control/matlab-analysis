function st_plot_mode(obj, ~, val)

modes = enumeration('sc_tool.PlotModeEnum');
obj.plot_mode = modes(val);

end