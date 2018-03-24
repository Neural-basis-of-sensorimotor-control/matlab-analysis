function reset_axes(obj, h_axes, str_ylabel)

if isempty(h_axes) || ~ishandle(h_axes)
  return
end

cla(h_axes);
hold(h_axes, 'on');

xlim(h_axes, [obj.pretrigger obj.posttrigger]);
xlabel(h_axes, 'Time [s]');
ylabel(h_axes, str_ylabel);
set(h_axes, 'XColor', [1 1 1], 'YColor', [1 1 1], 'Color', ...
  [0 0 0], 'Box', 'off');
grid(h_axes,'on');

end