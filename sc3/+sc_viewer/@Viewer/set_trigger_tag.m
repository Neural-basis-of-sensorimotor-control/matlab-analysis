function set_trigger_tag(obj, trigger_tag)

if isnumeric(trigger_tag) || ischar(trigger_tag)
  trigger_tag = get_item(obj.get_trigger_tags(), trigger_tag);
end

obj.trigger_tag = trigger_tag;

end