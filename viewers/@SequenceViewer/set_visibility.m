%Change visibility of all panels except input panel
function set_visibility(obj, visible, panel)
if isnumeric(visible) || islogical(visible)
    if visible
        visible = 'on';
    else
        visible = 'off';
    end
end
for k=1:obj.panels.n
    if obj.panels.get(k) ~= panel
        set(obj.panels.get(k),'visible',visible);
    end
end
end
