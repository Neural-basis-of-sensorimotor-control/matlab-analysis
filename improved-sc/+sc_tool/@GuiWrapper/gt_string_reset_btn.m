function str = gt_string_reset_btn(~, ui_object)

switch obj.enabled
  
  case 'on'
    ui_object.enabled = 'off';
  case 'off'
    ui_object.enabled = 'on';
end

str = 'Reset buttons';

end