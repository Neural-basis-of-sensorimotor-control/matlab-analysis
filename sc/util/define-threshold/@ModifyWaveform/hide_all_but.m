function hide_all_but(obj, threshold_wrapper)

reset_axes(obj);

indx                 = obj.thresholds == threshold_wrapper;
obj.thresholds(indx) = obj.thresholds(indx);

init_plot(obj);

end