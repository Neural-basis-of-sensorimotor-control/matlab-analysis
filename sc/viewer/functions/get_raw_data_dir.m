function val = get_raw_data_dir()

global RAW_DATA_DIR

if isempty(RAW_DATA_DIR)
  
  RAW_DATA_DIR = read_sc_settings('raw_data_dir');
  
end

if ~isempty(RAW_DATA_DIR) && RAW_DATA_DIR(end) ~= filesep
  RAW_DATA_DIR(end+1) = filesep;
end

val = RAW_DATA_DIR;

end
