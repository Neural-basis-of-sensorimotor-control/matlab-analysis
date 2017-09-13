function plot_starting_point(obj, x_, y_)

plot_starting_point@DefineThreshold(obj, x_, y_);

if ~obj.threshold_has_been_plotted

  import_threshold(obj, obj.threshold, obj.signal.dt);
  
  obj.threshold_has_been_plotted = true;
  
end

plot_limits(obj);

end