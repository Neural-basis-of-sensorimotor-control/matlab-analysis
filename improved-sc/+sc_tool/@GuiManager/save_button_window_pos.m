function save_button_window_pos(obj)

[x, y, w, h] = get_position(obj.button_window);
sc_settings.set_button_window_position([x y w h]);

end