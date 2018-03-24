function callback_new_threshold(obj, ~, ~)

obj.waveform.add(ScThreshold([], [], [], []));
obj.threshold_indx = obj.waveform.n;

obj.plot_mode = obj.edit_threshold;

end