function callback_delete_threshold(obj, ~, ~)

obj.waveform.list(obj.threshold_indx) = [];
obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;

end