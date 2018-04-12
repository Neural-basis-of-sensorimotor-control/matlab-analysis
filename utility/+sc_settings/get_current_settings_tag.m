function tag = get_current_settings_tag()

global CURRENT_SC_SETTINGS_TAG

if isempty(CURRENT_SC_SETTINGS_TAG)
  CURRENT_SC_SETTINGS_TAG = sc_settings.tags.DEFAULT;
end

tag = CURRENT_SC_SETTINGS_TAG;



end