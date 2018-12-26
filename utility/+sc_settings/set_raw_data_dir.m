function set_raw_data_dir(val)

if ~nargin
  
  val = uigetdir(sc_settings.get_raw_data_dir(), ...
    'Select raw data directory');
  
  if ~ischar(val)
    return
  end
  
end

% if isunix && ~startsWith(val, '/')
%   val = ['/' val];
% end

sc_settings.write_settings(sc_settings.tags.RAW_DATA_DIR, val);

end