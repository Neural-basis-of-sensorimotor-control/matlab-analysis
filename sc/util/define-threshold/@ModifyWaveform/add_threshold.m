function add_threshold(obj)
% add_threshold(ModifyThreshold)

threshold = ScThreshold([], [], [], []);

obj.waveform.add(threshold);

thr        = ModifyWaveformChild(obj.h_axes, obj.waveform.parent, threshold);
thr.parent = obj;

if isempty(obj.thresholds)
  
  x0 = mean(xlim(obj.h_axes));
  y0 = mean(ylim(obj.h_axes));
  
else
  
  dx = .05*sc_range(xlim(obj.h_axes));
  dy = .05*sc_range(xlim(obj.h_axes));
  
  x0 = mean(cell2mat({obj.thresholds.x0})) + dx;
  y0 = mean(cell2mat({obj.thresholds.y0})) + dy;
  
end

thr.x0 = x0;
thr.y0 = y0;

obj.thresholds = add_to_list(obj.thresholds, thr);

colors = varycolor(length(obj.thresholds));

for i=1:length(obj.thresholds)  
  obj.thresholds(i).color = colors(i, :);
end

for i=1:length(obj.thresholds)
  delete_all_objects(obj.thresholds(i));
end

for i=1:length(obj.thresholds)
  plot_starting_point(obj.thresholds(i), obj.thresholds(i).x0, obj.thresholds(i).y0);
end

end