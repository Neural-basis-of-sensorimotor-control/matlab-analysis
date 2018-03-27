function [v_sweep, t] = plot_sweep(obj, h_axes, signal, v, btn_dwn_fcn)

v_sweep = [];
t = [];

if isempty(h_axes)
  return
end

if nargin < 5
  btn_dwn_fcn = [];
end


[v_sweep, t] = sc_get_sweeps(v, 0, obj.trigger_time, obj.pretrigger, ...
  obj.posttrigger, signal.dt);

if ~isempty(obj.v_zero_for_t)
  
  [~, indx_t0] = min(abs(t - obj.v_zero_for_t));
  
  for i=1:size(v_sweep, 2)
    v_sweep(:, i) = v_sweep(:, i) - v_sweep(indx_t0, i);
  end
  
end

for i=1:size(v_sweep, 2)
  
  plot(h_axes, t, v_sweep(:,i), 'Color', 'r', ...
    'ButtonDownFcn', btn_dwn_fcn);
  
end


end