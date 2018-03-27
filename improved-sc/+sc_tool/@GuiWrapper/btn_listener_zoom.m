function btn_listener_zoom(obj, ui_object)

if obj.zoom_on
  set(ui_object, 'FontWeight', 'bold');
else
  set(ui_object, 'FontWeight', 'normal');
end

end