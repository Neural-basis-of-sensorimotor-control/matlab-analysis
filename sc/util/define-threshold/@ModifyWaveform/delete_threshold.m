function delete_threshold(obj, threshold_wrapper)

indx = obj.thresholds == threshold_wrapper;

threshold = obj.thresholds(indx).threshold;

obj.waveform.list(obj.waveform.list == threshold) = [];

obj.waveform.list(indx) = [];

obj.has_unsaved_changes = true;

reset_axes(obj);

init_plot(obj);

end