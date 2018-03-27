function [v_sweep, t] = plot_all(obj, h_axes, signal, v, indx)

v_sweep = [];
t = [];

if isempty(h_axes)
  return
end

all_trigger_times = obj.all_trigger_times;

if nargin < 5
  indx = true(size(all_trigger_times));
end

[v_sweep, t] = sc_get_sweeps(v, 0, all_trigger_times(indx), obj.pretrigger, ...
  obj.posttrigger, signal.dt);

for i=1:size(v_sweep, 2)
  
  plot(h_axes, t, v_sweep(:,i), 'Color', 'r');
  
end

end