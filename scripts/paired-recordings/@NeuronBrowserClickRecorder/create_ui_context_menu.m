function c = create_ui_context_menu(obj, index)

c = uicontextmenu();

uimenu(c, 'Label', 'Remove', 'Callback', @(~, ~) remove_point(obj, index));

end