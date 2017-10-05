function delete_threshold(obj, threshold_wrapper)

reset_axes(obj);

indx = obj.thresholds == threshold_wrapper;

threshold = obj.thresholds(indx).threshold;

obj.thresholds(indx)                              = [];
obj.waveform.list(obj.waveform.list == threshold) = [];

obj.has_unsaved_changes = true;

init_plot(obj);

end