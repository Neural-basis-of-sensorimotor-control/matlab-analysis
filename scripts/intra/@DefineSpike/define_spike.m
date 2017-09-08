function define_spike(obj, v, dt)

obj.v   = v;
obj.dt  = dt;

obj.threshold = ScThreshold([], [], [], []);
obj.x0        = [];
obj.y0        = [];

obj.define_spike_update();

obj.update_fcn = @obj.define_spike_update;

end