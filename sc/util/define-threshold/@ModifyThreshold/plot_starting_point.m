function plot_starting_point(obj, x_, y_)

plot_starting_point@DefineThreshold(obj, x_, y_);

import_threshold(obj, obj.threshold, obj.signal.dt);

plot_limits(obj);
  
end