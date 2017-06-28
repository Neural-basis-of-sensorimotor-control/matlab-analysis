function define_spike(obj, x, y, dt)

obj.x = x;
obj.y = y;
obj.dt = dt;

obj.spike = Spike;
obj.x0 = [];
obj.y0 = [];

obj.define_spike_update();

obj.update = @obj.define_spike_update;

end