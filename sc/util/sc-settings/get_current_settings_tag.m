function tag = get_current_settings_tag()

global CURRENT_SC_SETTINGS_TAG

if isempty(CURRENT_SC_SETTINGS_TAG)
  CURRENT_SC_SETTINGS_TAG = get_default_settings_tag();
end

tag = CURRENT_SC_SETTINGS_TAG;



end