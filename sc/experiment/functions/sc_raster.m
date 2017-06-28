function [time, sweep, h_plot] = sc_raster(varargin)
%sc_raster(trigger_time, spike_time, pretrigger, posttrigger)
%sc_raster(axes_handle, ...)
%sc_raster(marker_type, ...)
%[time, sweep, h_plot] = sc_raster(...)

if ishandle(varargin{1})
  h_axes = varargin{1};
  varargin = varargin(2:end);
else
  h_axes = gca;
end

if ischar(varargin{1})
  plot_char = varargin{1};
  varargin = varargin(2:end);
else
  plot_char = 'k.';
end

trigger_time = varargin{1};
spike_time = varargin{2};
pretrigger = varargin{3};
posttrigger = varargin{4};

[time, sweep] = sc_perievent_sweep(trigger_time, spike_time, pretrigger, posttrigger);

h_plot = plot(time, sweep, plot_char, 'MarkerSize', 1, 'Color', [0 0 0]);
set(h_axes, 'YDir', 'reverse')%, 'FontSize', 14);

xlabel(h_axes, 'Time [s]')
ylabel(h_axes, 'Sweep nbr')

xlim(h_axes, [pretrigger posttrigger])

if ~isempty(sweep)
  ylim(h_axes, [min(sweep)-1 max(sweep)+1])
end

grid on

end