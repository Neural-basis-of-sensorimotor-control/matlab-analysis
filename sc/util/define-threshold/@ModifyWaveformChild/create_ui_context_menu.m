function c = create_ui_context_menu(obj, indx)

c = create_ui_context_menu@ModifyThreshold(obj, indx);

uimenu(c, 'Label', 'Delete threshold', 'Callback', ...
  @(~,~) delete_threshold(obj.parent, obj));

uimenu(c, 'Label', 'Hide', 'Callback', ...
  @(~, ~) hide_threshold(obj.parent, obj));

uimenu(c, 'Label', 'Hide other', 'Callback', ...
  @(~, ~) hide_all_but(obj.parent, obj));

end