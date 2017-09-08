function define_spike_update(obj)

clf(obj.h_axes);

hold(obj.h_axes, 'on');

t = (1:size(obj.v, 1)) * obj.dt;

for i=1:size(obj.v, 2)
  
  plot(t, obj.v(:,i), 'ButtonDownFcn', @obj.define_slope_stop_btndwn);
  
end

set(obj.h_axes, 'ButtonDownFcn', @obj.define_slope_stop_btndwn);

end