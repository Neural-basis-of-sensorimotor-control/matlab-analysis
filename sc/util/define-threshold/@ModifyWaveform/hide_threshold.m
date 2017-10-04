function hide_threshold(obj, threshold_wrapper)

indx                 = obj.thresholds == threshold_wrapper;
obj.thresholds(indx) = [];

reset_axes(threshold_wrapper);

reset_axes(obj);
init_plot(obj);

end