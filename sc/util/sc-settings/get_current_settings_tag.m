function tag = get_current_settings_tag()

global CURRENT_SC_SETTINGS_TAG

tag = CURRENT_SC_SETTINGS_TAG;

if isempty(tag)
  tag = get_default_settings_tag();
end

end