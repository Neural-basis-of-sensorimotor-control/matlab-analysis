function delete_threshold(obj, threshold_wrapper)

indx = obj.thresholds == threshold_wrapper;

hide_threshold(obj, threshold_wrapper);

threshold = obj.thresholds(indx).threshold;

obj.waveform.list(obj.waveform.list == threshold) = [];

obj.has_unsaved_changes = true;

end