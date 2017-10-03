function c = create_ui_context_menu(obj, indx)

c = create_ui_context_menu@ModifyThreshold(obj, indx);

uimenu(c, 'Label', 'Hide', 'Callback', ...
  @(~, ~) hide_threshold(obj.parent, obj));

end