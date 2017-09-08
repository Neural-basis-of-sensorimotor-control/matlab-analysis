function define_obj = define(v, dt)

if size(v, 1) == 1 && size(v, 2) > 1
  v = v';
end

define_obj = DefineThreshold();

define_obj.h_axes = gca;
define_obj.v      = v;
define_obj.dt     = dt;

define_obj.clear_settings();


define_obj.define_threshold();

end