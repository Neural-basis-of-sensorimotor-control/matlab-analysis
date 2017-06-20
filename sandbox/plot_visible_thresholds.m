function plot_visible_thresholds(h_has_unsaved_changes, h_axes, thresholds, t, v)

tmin = min(t);

x0                  = [];
y0                  = [];
detected_thresholds = [];
dt                  = mean(diff(t));

for i=1:length(thresholds)
  
  spikepos = thresholds(i).match_v(v);
  
  for j=1:length(spikepos)
    
    x0                  = add_to_list(x0, spikepos(j)*dt - tmin);
    y0                  = add_to_list(y0, v(spikepos(j)));
    detected_thresholds = add_to_list(detected_thresholds, thresholds(j));

  end
  
end


edit_threshold(h_has_unsaved_changes, h_axes, detected_thresholds, x0, y0, dt);

end