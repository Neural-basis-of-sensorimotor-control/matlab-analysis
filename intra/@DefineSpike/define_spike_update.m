function define_spike_update(obj)

clf
plot(obj.x, obj.y, 'ButtonDownFcn', @obj.define_slope_stop_btndwn);
set(gca, 'ButtonDownFcn', @obj.define_slope_stop_btndwn);

end