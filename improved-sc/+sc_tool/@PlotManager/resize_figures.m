function resize_figures(obj)

pos = sc_settings.get_button_window_position();

if length(pos) == 4
  set_position(obj.button_window, pos(1), pos(2), pos(3), pos(4));
end

pos = sc_settings.get_plot_window_position();

if length(pos) == 4
  set_position(obj.plot_window, pos(1), pos(2), pos(3), pos(4));
end

end