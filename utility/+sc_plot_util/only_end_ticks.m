function only_end_ticks(h_axes, dimension)
% only_end_ticks(h_axes, dimension)

if ~nargin
  h_axes = gca;
end

if nargin < 2
  dimension = 'XY';
end

if length(dimension) > 1
  
  debug_mode = sc_debug.get_mode();
  sc_debug.set_mode(false);
  vectorize_fcn(@(x) sc_plot_util.only_end_ticks(h_axes, x), dimension);
  sc_debug.set_mode(debug_mode);
  return
  
end

str_tick       = [dimension 'Tick'];
str_tick_label = [dimension 'TickLabel'];
tick           = get(h_axes, str_tick);
tick_label     = get(h_axes, str_tick_label);

for i=2:length(tick_label)-1
  tick_label(i) = {''};
end

set(h_axes, str_tick, tick, str_tick_label, tick_label);

end