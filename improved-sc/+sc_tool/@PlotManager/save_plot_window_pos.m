function save_plot_window_pos(obj)

[x, y, w, h] = get_position(obj.plot_window);
sc_settings.set_plot_window_position([x y w h]);

end