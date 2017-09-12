function threshold = export_to_threshold(obj)

threshold = export_to_threshold@DefineThreshold(obj, obj.signal.dt, obj.threshold);

end