function enable_listener(obj, ui_object)

switch obj.enabled
  
  case 'on'
    set(ui_object, 'Enable', 'off');
  case 'off'
    set(ui_object, 'Enable', 'on');
  otherwise
    error('incorrect value: %s', obj.enable);
    
end

end
