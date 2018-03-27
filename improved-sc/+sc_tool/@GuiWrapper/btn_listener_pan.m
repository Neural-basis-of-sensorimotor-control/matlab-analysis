function btn_listener_pan(obj, ui_object)

if obj.pan_on
  set(ui_object, 'FontWeight', 'bold');
else
  set(ui_object, 'FontWeight', 'normal');
end

end