function set_raw_data_dir(val)

global RAW_DATA_DIR

RAW_DATA_DIR = val;

write_sc_settings('raw_data_dir', RAW_DATA_DIR);

end