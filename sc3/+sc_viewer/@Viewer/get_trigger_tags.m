function trigger_tags = get_trigger_tags(obj)

if isempty(obj.trigger_parent)
  trigger_tags = {};
else
  trigger_tags = obj.trigger_parent.get_trigger_tags();
end

end