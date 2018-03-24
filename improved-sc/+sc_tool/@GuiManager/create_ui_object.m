function ui_object = create_ui_object(style, varargin)

ui_object = uicontrol('Style', style, 'Visible', 'off');

setwidth(ui_object, sc_tool.UiControl.default_width);
setheight(ui_object, sc_tool.UiControl.default_height);

if strcmpi(style, 'text')
  set(ui_object, 'HorizontalAlignment', 'left');
end

if ~isempty(varargin)
  set(ui_object, varargin{:});
end

end