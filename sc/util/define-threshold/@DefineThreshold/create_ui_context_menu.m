function c = create_ui_context_menu(obj, indx)

c = uicontextmenu;

uimenu(c, 'Label', 'Remove limit', 'Callback', ...
  @(~,~) remove_limit(obj, indx));

end