function [v_out, t_out] = plot_all(obj, indx)

all_trigger_times = obj.all_trigger_times;

if nargin == 1
  indx = true(size(all_trigger_times));
end

[v, t] = sc_get_sweeps(obj.v1, 0, all_trigger_times(indx), obj.pretrigger, ...
  obj.posttrigger, obj.signal1.dt);

for i=1:size(v, 2)
  
  plot(obj.signal1_axes, t, v(:,i), 'Color', 'r');
  
end

if nargout
  v_out = v;
end

if nargout >= 2
  t_out = t;
end

end